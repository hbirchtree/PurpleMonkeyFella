#pragma once

#include <QObject>

#if !defined(PURPLE_NO_NETWORK)
#include <QNetworkAccessManager>
#endif

#if defined(PURPLE_AUDIOOUT)
#include <QMediaPlayer>
#endif

class QMediaPlayer;
class QBuffer;

class Speech : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
  public:
    explicit Speech(QObject* parent = nullptr);
    virtual ~Speech();

    bool running() const;

  signals:
    void runningChanged();

  public slots:
    void say(QString const& sentence);

  private slots:
    void onSampleReceived(QNetworkReply *reply);
    void onMediaPlayerError(QMediaPlayer::Error error, QString const& errorString);

  private:
#if defined(PURPLE_AUDIOOUT)
    QNetworkAccessManager* m_networkManager{nullptr};
    QMediaPlayer* m_player{nullptr};
    QBuffer* m_bufferDevice{nullptr};
    QByteArray m_audioBuffer;
#endif
};
