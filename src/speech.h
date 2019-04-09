#pragma once

#include <QObject>
#include <QTextToSpeech>
#include <QNetworkAccessManager>
#include <QAudioOutput>
#include <QBuffer>

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
    void voiceStateChange(QTextToSpeech::State state);

  private:
    QTextToSpeech* m_speech;
    QNetworkAccessManager m_net;
    QAudioOutput* m_output;

    QBuffer* m_audioBuffer;
    QByteArray m_currentBuffer;
};
