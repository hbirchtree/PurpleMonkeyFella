#ifndef SPEECH_H
#define SPEECH_H

#include <QObject>
#include <QTextToSpeech>

class Speech : public QObject
{
    Q_OBJECT
public:
    explicit Speech(QObject *parent = nullptr);
    virtual ~Speech();

signals:

public slots:
    void say(QString const& sentence);

private:
    QTextToSpeech* m_speech;
};

#endif // SPEECH_H
