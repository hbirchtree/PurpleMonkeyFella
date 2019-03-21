#include "randomevents.h"
#include <chrono>

RandomEvents::RandomEvents(QObject* parent) :
    QObject(parent), m_timer(new QTimer(this))
{
    connect(this, &RandomEvents::intervalChanged, [&](int interval) {
        m_timer->setInterval(std::chrono::milliseconds(interval));
    });
    connect(m_timer, &QTimer::timeout, [&]() { newEvent(); });

    setInterval(5000);
}

RandomEvents::~RandomEvents()
{
}

void RandomEvents::prepare()
{
    m_timer->start();
}
