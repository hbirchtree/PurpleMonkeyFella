#include "speech.h"
#include <QVoice>
#include <QVector>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDebug>

Speech::Speech(QObject* parent) :
    QObject(parent), m_speech(new QTextToSpeech(this)), m_net(this), m_audioBuffer(nullptr)
{
    QAudioFormat fmt;
    fmt.setCodec("audio/pcm");
    fmt.setChannelCount(1);
    fmt.setSampleSize(16);
    fmt.setSampleRate(44100);
    fmt.setSampleType(QAudioFormat::UnSignedInt);
    fmt.setByteOrder(QAudioFormat::LittleEndian);

    QAudioDeviceInfo info(QAudioDeviceInfo::defaultOutputDevice());

    if(!info.isFormatSupported(fmt))
        qDebug("reeee");

    m_output = new QAudioOutput(fmt, this);

    connect(m_output, &QAudioOutput::stateChanged, [&](QAudio::State state) {
        qDebug() << state;
    });

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

        qDebug("Got file");

        if(m_audioBuffer)
            m_audioBuffer->deleteLater();

        m_currentBuffer = reply->readAll();
        m_audioBuffer = new QBuffer(&m_currentBuffer, this);

        if(!m_audioBuffer->open(QIODevice::ReadOnly))
        {
            qDebug("Failed to open buffer");
            return;
        }

        m_output->start(m_audioBuffer);
    });
}

Speech::~Speech()
{
}

void Speech::say(const QString& sentence)
{
    m_output->stop();

    QString cpy = sentence;
    QNetworkRequest req(QUrl(
                            "http://localhost:23451/SAPI4.wav?text="
                            + cpy.replace(" ", "%20")
                            + "&voice=Bonzi&pitch=150"));

    m_net.get(req);
}

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
