#pragma once

#include <QObject>
#include <QTimer>
#include <random>

class RandomEvents : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int interval READ interval WRITE setInterval NOTIFY intervalChanged)
  public:
    explicit RandomEvents(QObject* parent = nullptr);
    virtual ~RandomEvents();

    int interval() const
    {
        return m_interval;
    }

    Q_INVOKABLE int randRange(int start, int end);

signals:
    void newEvent();

    void intervalChanged(int interval);

public slots:
    void prepare();
    void stop();

    void setInterval(int interval)
    {
        if (m_interval == interval)
            return;

        m_interval = interval;
        emit intervalChanged(m_interval);
    }

private:
    QTimer* m_timer;
    int m_interval;

    std::mt19937 rand_engine;
};
