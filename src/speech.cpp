#include "speech.h"
#include <QVector>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QTemporaryFile>
#include <QSoundEffect>
#if defined(PURPLE_VOICE)
#include <QVoice>
#endif

#include <QDebug>

Speech::Speech(QObject* parent) :
    QObject(parent),
    #if defined(PURPLE_VOICE)
    m_speech(new QTextToSpeech(this)),
    #endif
    m_net(this),
    m_audioBuffer(nullptr),
    m_currentSound(new QSoundEffect(this))
{
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
            break;
        default:
            break;
        }
    });

    connect(m_currentSound, &QSoundEffect::playingChanged, [&]() {
        if(!m_currentSound->isPlaying())
            stopped();
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

        QTemporaryFile soundDump("XXXXXXXXXXXXX.wav");
        soundDump.setAutoRemove(false);

        if(soundDump.open())
        {
            soundDump.write(reply->readAll());
            soundDump.close();

            qDebug() << soundDump.fileName();
            m_currentSound->setSource("file://" + soundDump.fileName());
        }
    });
}

Speech::~Speech()
{
}

void Speech::say(const QString& sentence)
{
    m_currentSound->stop();

    QString cpy = sentence;
    QNetworkRequest req(QUrl(
                            "http://localhost:23451/SAPI4.wav?text="
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
