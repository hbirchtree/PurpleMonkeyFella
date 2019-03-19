#include "randomevents.h"
#include <chrono>

RandomEvents::RandomEvents(QObject* parent) :
    QObject(parent), m_timer(new QTimer(this))
{
    connect(m_timer, &QTimer::timeout, [&]() { newEvent(); });

    m_timer->setInterval(std::chrono::seconds(5));
}

RandomEvents::~RandomEvents()
{
}

void RandomEvents::prepare()
{
    m_timer->start();
}
