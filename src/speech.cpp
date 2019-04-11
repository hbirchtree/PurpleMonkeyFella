#include "speech.h"
#include <QVector>
#include <QNetworkRequest>
#include <QNetworkReply>

#include <QAudioFormat>

#if defined(PURPLE_QSOUND)
#include <QTemporaryFile>
#include <QFile>
#include <QSoundEffect>
#endif

#if defined(PURPLE_VOICE)
#include <QVoice>
#endif

#if defined(PURPLE_AUDIOOUT)
#include <QBuffer>
#endif

#include <QDebug>

Speech::Speech(QObject* parent) :
    QObject(parent),
    #if defined(PURPLE_VOICE)
    m_speech(new QTextToSpeech(this)),
    #endif
    m_net(this)
  #if defined(PURPLE_QSOUND)
    , m_currentSound(new QSoundEffect(this))
  #endif
  #if defined(PURPLE_AUDIOOUT)
    , m_output(nullptr)
  #endif
{
#if defined(PURPLE_QSOUND)
    connect(m_currentSound, &QSoundEffect::statusChanged, [&]() {
        qDebug() << m_currentSound->status();

        switch(m_currentSound->status()) {
        case QSoundEffect::Loading:
            break;
        case QSoundEffect::Ready:
            m_currentSound->play();
            this->started();
            break;
        case QSoundEffect::Error:
            qDebug() << "Sadface";
            qDebug() << m_currentSound->supportedMimeTypes();
            QFile(m_currentSound->source().fileName()).remove();
            break;
        default:
            break;
        }
    });

    connect(m_currentSound, &QSoundEffect::playingChanged, [&]() {
        if(!m_currentSound->isPlaying())
        {
            stopped();
            QFile(m_currentSound->source().fileName()).remove();
        }
    });
#endif
#if defined(PURPLE_AUDIOOUT)
    QAudioFormat fmt;
    fmt.setByteOrder(QAudioFormat::LittleEndian);
    fmt.setChannelCount(1);
    fmt.setCodec("audio/pcm");
    fmt.setSampleRate(11025);
    fmt.setSampleType(QAudioFormat::SignedInt);
    fmt.setSampleSize(16);

    QAudioDeviceInfo dev = QAudioDeviceInfo::defaultOutputDevice();

    if(!dev.isFormatSupported(fmt))
        qDebug() << "Unsupported audio format";

    m_output = new QAudioOutput(fmt, this);

    connect(m_output, &QAudioOutput::stateChanged, [&](QAudio::State state)
    {
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
            stopped();
            break;

        case QAudio::IdleState:
            stopped();
//            if(m_currentBuffer)
//            {
//                m_currentBuffer->deleteLater();
//                m_currentBuffer = nullptr;
//            }
            break;
        default:
            break;
        }
    });
#endif

    connect(&m_net, &QNetworkAccessManager::finished,
            [&](QNetworkReply* reply) {
        if(reply->error() != QNetworkReply::NoError)
        {
            qDebug("Error: %s", reply->errorString().toStdString().c_str());
            qDebug() << reply->readAll().size();
            reply->deleteLater();
            return;
        }

        if(!reply->header(QNetworkRequest::ContentTypeHeader).toString().startsWith("audio/"))
        {
            qDebug("Invalid data type");
            reply->deleteLater();
            return;
        }

#if defined(PURPLE_QSOUND)
        QTemporaryFile soundDump("XXXXXXXXXXXXX.wav");
        soundDump.setAutoRemove(false);

        if(soundDump.open())
        {
            soundDump.write(reply->readAll());
            soundDump.close();

            qDebug() << soundDump.fileName() << reply->header(QNetworkRequest::ContentTypeHeader).toString();
            qDebug() << QFile(soundDump.fileName()).exists();

            m_currentSound->setSource(soundDump.fileName());
        }
#endif
#if defined(PURPLE_AUDIOOUT)
        qDebug() << "New audio";

        if(!m_buffer)
        {
            m_buffer = new QBuffer(this);

        }

        m_buffer->close();

        m_currentData = reply->readAll();
        m_buffer->setData(m_currentData);

        if(!m_buffer->open(QBuffer::ReadOnly))
            qDebug() << "Buffer operations failed";

        m_output->start(m_buffer);
#endif
    });
}

Speech::~Speech()
{
}

void Speech::say(const QString& sentence)
{
#if defined(PURPLE_QSOUND)
    m_currentSound->stop();
#endif
#if defined(PURPLE_AUDIOOUT)
    m_output->stop();
    m_output->reset();
#endif

    QString cpy = sentence;
    QNetworkRequest req(QUrl(
                            "http://bonzi.hackerspace-ntnu.no:23451/SAPI4.wav?text="
                            + cpy.replace(" ", "%20")
                            + "&voice=Bonzi&pitch=150"));

    m_net.get(req);
}

#if defined(PURPLE_VOICE)
void Speech::voiceStateChange(QTextToSpeech::State state)
{
    switch(state)
    {
    case QTextToSpeech::State::Speaking:
    {
        started();
        break;
    }
    case QTextToSpeech::State::Ready:
    case QTextToSpeech::State::Paused:
    {
        stopped();
        break;
    }
    default:
        break;
    }
}
#endif
