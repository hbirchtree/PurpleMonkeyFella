#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QAudioOutput>
#include <QBuffer>
#if defined(PURPLE_VOICE)
#include <QTextToSpeech>
#endif

class QSoundEffect;

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
#if defined(PURPLE_VOICE)
//    QTextToSpeech* m_speech;
#endif
    QNetworkAccessManager m_net;
    QAudioOutput* m_output;

    QBuffer* m_audioBuffer;
    QByteArray m_currentBuffer;
    QSoundEffect* m_currentSound;
};
