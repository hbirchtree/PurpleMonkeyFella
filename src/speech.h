#pragma once

#include <QObject>

#if !defined(PURPLE_NO_MEDIA)
#define PURPLE_AUDIOOUT
#endif

#if defined(PURPLE_AUDIOOUT)
#include <QAudioOutput>
#endif

#if !defined(PURPLE_NO_NETWORK)
#include <QNetworkAccessManager>
#endif

class QSoundEffect;
class QBuffer;

class Speech : public QObject
{
    Q_OBJECT
  public:
    explicit Speech(QObject* parent = nullptr);
    virtual ~Speech();

  signals:
    void started();
    void stopped();

  public slots:
    void say(QString const& sentence);

  private slots:
#if defined(PURPLE_VOICE)
    void voiceStateChange(QTextToSpeech::State state);
#endif

  private:
#if !defined(PURPLE_NO_NETWORK)
    QNetworkAccessManager m_net;
#endif

#if defined(PURPLE_AUDIOOUT)
    QAudioOutput* m_output = nullptr;
    QByteArray m_currentData;
    QBuffer* m_buffer = nullptr;
#endif
};
