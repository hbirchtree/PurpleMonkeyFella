#include "randomevents.h"

#include <chrono>
#include <ctime>

RandomEvents::RandomEvents(QObject* parent) :
    QObject(parent), m_timer(new QTimer(this))
{
    connect(this, &RandomEvents::intervalChanged, [&](int interval) {
        m_timer->stop();
        m_timer->setInterval(std::chrono::milliseconds(interval));
        m_timer->start();
    });
    connect(m_timer, &QTimer::timeout, [&]() { newEvent(); });

    setInterval(5000);

    rand_engine.seed(
        static_cast<std::mt19937::result_type>(std::time(nullptr)));
}

RandomEvents::~RandomEvents()
{
}

int RandomEvents::randRange(int start, int end)
{
    std::uniform_int_distribution<int> dist(start, end);

    return dist(rand_engine);
}

void RandomEvents::prepare()
{
    m_timer->start();
}

void RandomEvents::stop()
{
    m_timer->stop();
}
