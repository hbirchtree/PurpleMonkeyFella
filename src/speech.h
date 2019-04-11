#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QAudioOutput>

#if defined(Q_OS_MAC_)
#define PURPLE_QSOUND
#else
#define PURPLE_AUDIOOUT
#endif

#if defined(PURPLE_VOICE)
#include <QTextToSpeech>
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
    QNetworkAccessManager m_net;

#if defined(PURPLE_VOICE)
    QTextToSpeech* m_speech;
#endif
#if defined(PURPLE_QSOUND)
    QSoundEffect* m_currentSound;
#endif
#if defined(PURPLE_AUDIOOUT)
    QAudioOutput* m_output = nullptr;
    QByteArray m_currentData;
    QBuffer* m_buffer = nullptr;
#endif
};
