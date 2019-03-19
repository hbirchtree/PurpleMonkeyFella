#include "speech.h"

Speech::Speech(QObject* parent) :
    QObject(parent), m_speech(new QTextToSpeech(this))
{
}

Speech::~Speech()
{
}

void Speech::say(const QString &sentence)
{
    m_speech->stop();

    m_speech->say(sentence);
}
