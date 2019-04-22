#include "speech.h"

#if !defined(PURPLE_NO_NETWORK)
#include <QNetworkReply>
#include <QNetworkRequest>
#endif

#if defined(PURPLE_QSOUND)
#include <QFile>
#include <QSoundEffect>
#include <QTemporaryFile>
#endif

#if defined(PURPLE_AUDIOOUT)
#include <QAudioFormat>
#include <QBuffer>
#endif

#if defined(Q_OS_WASM)
#include <emscripten.h>
#endif

#include <QDebug>

Speech::Speech(QObject* parent) :
    QObject(parent)
#if !defined(PURPLE_NO_NETWORK)
    ,
    m_net(this)
#endif
#if defined(PURPLE_AUDIOOUT)
    ,
    m_output(nullptr)
#endif
{
#if defined(PURPLE_AUDIOOUT)
    QAudioFormat fmt;
    fmt.setByteOrder(QAudioFormat::LittleEndian);
    fmt.setChannelCount(1);
    fmt.setCodec("audio/pcm");
    fmt.setSampleRate(11025);
    fmt.setSampleType(QAudioFormat::SignedInt);
    fmt.setSampleSize(16);

    QAudioDeviceInfo dev = QAudioDeviceInfo::defaultOutputDevice();

    if(!dev.isFormatSupported(fmt)) {
        qDebug() << "Unsupported audio format";

        fmt.setSampleRate(22050);

        if(dev.isFormatSupported(fmt))
            qDebug() << "pcm" << fmt.sampleRate() << fmt.sampleSize() << fmt.sampleType();

        fmt.setSampleRate(44100);

        if(dev.isFormatSupported(fmt))
            qDebug() << "pcm" << fmt.sampleRate() << fmt.sampleSize() << fmt.sampleType();

        fmt.setSampleType(QAudioFormat::UnSignedInt);

        if(dev.isFormatSupported(fmt))
            qDebug() << "pcm" << fmt.sampleRate() << fmt.sampleSize() << fmt.sampleType();
    }

    m_output = new QAudioOutput(fmt, this);

    connect(m_output, &QAudioOutput::stateChanged, [&](QAudio::State state) {
        qDebug() << state;
        switch(state)
        {
        case QAudio::ActiveState:
            started();
            break;
        case QAudio::StoppedState:
            if(m_output->error() != QAudio::NoError)
            {
                qDebug() << "Error:" << m_output->error();
            }

        case QAudio::IdleState:
            stopped();
            break;
        default:
            break;
        }
    });
#endif

#if !defined(PURPLE_NO_NETWORK)
    connect(
        &m_net, &QNetworkAccessManager::finished, [&](QNetworkReply* reply) {
            if(reply->error() != QNetworkReply::NoError)
            {
                qDebug("Error: %s", reply->errorString().toStdString().c_str());
                qDebug() << reply->readAll().size();
                reply->deleteLater();
                return;
            }

            if(!reply->header(QNetworkRequest::ContentTypeHeader)
                    .toString()
                    .startsWith("audio/"))
            {
                qDebug("Invalid data type");
                reply->deleteLater();
                return;
            }

#if defined(PURPLE_AUDIOOUT)
            qDebug() << "New audio";

            if(!m_buffer)
            {
                m_buffer = new QBuffer(this);
            }

            m_buffer->close();

            m_currentData = reply->readAll();
            m_currentData = m_currentData.right(m_currentData.size() - 48);
            m_buffer->setData(m_currentData);

            if(!m_buffer->open(QBuffer::ReadOnly))
                qDebug() << "Buffer operations failed";

            m_output->start(m_buffer);
#endif
        });
#endif
}

Speech::~Speech()
{
}

void Speech::say(const QString& sentence)
{
#if defined(PURPLE_AUDIOOUT)
    m_output->stop();
    m_output->reset();
#endif

#if !defined(PURPLE_NO_NETWORK)
    QString cpy = sentence;

    QNetworkRequest req(QUrl(
        "https://api.birchy.dev/api/bonziProxy?say=" +
                            QUrl::toPercentEncoding(cpy)));

    m_net.get(req);
#endif

#if defined(Q_OS_WASM)
    std::string container = sentence.toStdString();
    char* raw_str = const_cast<char*>(container.c_str());

    EM_ASM_({
               Module.popEvent($0, $1);
    }, raw_str, container.size());
#endif
}
