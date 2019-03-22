#include "speech.h"
#include <QVoice>
#include <QVector>

Speech::Speech(QObject* parent) :
    QObject(parent), m_speech(new QTextToSpeech(this))
{
#if defined(Q_OS_MAC)
    m_speech->setPitch(-1);
    m_speech->setRate(-1);

    m_speech->setVoice(m_speech->availableVoices().at(0));
#else
    m_speech->setPitch(-1.);
    m_speech->setRate(-1.);
#endif

    connect(
        m_speech,
        &QTextToSpeech::stateChanged,
        this,
        &Speech::voiceStateChange);
}

Speech::~Speech()
{
}

void Speech::say(const QString& sentence)
{
    m_speech->stop();

    m_speech->say(sentence);
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
