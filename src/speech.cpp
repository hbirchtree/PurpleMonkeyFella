#include "speech.h"

#if defined(PURPLE_AUDIOOUT)
#include <QAudioDevice>
#include <QAudioFormat>
#include <QAudioOutput>
#include <QBuffer>
#include <QMediaPlayer>
#endif

#if !defined(PURPLE_NO_NETWORK)
#include <QNetworkReply>
#endif

#if defined(Q_OS_WASM)
#include <emscripten.h>
#endif

#include <QDebug>

Speech::Speech(QObject* parent)
    : QObject(parent)
#if defined(PURPLE_AUDIOOUT)
    , m_networkManager(new QNetworkAccessManager(this))
    , m_player(new QMediaPlayer(this))
    , m_bufferDevice(new QBuffer(&m_audioBuffer, this))
#endif
{
    m_networkManager->setRedirectPolicy(QNetworkRequest::NoLessSafeRedirectPolicy);

    m_player->setAudioOutput(new QAudioOutput(QAudioDevice(), this));

    connect(m_player, &QMediaPlayer::playbackStateChanged, this, &Speech::runningChanged);
    connect(m_player, &QMediaPlayer::errorOccurred, this, &Speech::onMediaPlayerError);
    connect(m_player, &QMediaPlayer::mediaStatusChanged, [](QMediaPlayer::MediaStatus status) {
        qDebug() << "Media status" << status;
    });

    connect(m_networkManager, &QNetworkAccessManager::finished, this, &Speech::onSampleReceived);
}

Speech::~Speech()
{
}

bool Speech::running() const
{
#if defined(PURPLE_AUDIOOUT)
    return m_player->playbackState() == QMediaPlayer::PlayingState;
#else
    return false;
#endif
}

void Speech::say(const QString& sentence)
{
    qDebug() << "Requesting line '" << sentence << "'";
#if defined(PURPLE_AUDIOOUT)
    QNetworkRequest voiceRequest(QUrl(
        "https://api.birchy.dev/sapi/speak.wav?voice=Bonzibuddy&speed=140&pitch=157&text=" +
                            QUrl::toPercentEncoding(sentence)));
    m_networkManager->get(voiceRequest);
#elif defined(Q_OS_WASM)
    std::string container = sentence.toStdString();
    char* raw_str = const_cast<char*>(container.c_str());

    EM_ASM_({
               Module.popEvent($0, $1);
    }, raw_str, container.size());
#else
    #error No Speech backend
#endif
}

void Speech::onSampleReceived(QNetworkReply *reply)
{
    m_player->stop();

    qDebug() << "Got response from" << reply->url() << reply->error();

    m_player->setSourceDevice(reply, reply->url());
    m_player->setPosition(0);
    m_player->play();

    connect(m_player, &QMediaPlayer::sourceChanged,
            reply, &QObject::deleteLater,
            Qt::SingleShotConnection);
}

void Speech::onMediaPlayerError(QMediaPlayer::Error error, const QString &errorString)
{
    qDebug() << "MediaPlayer Error:" << error << errorString;
}
