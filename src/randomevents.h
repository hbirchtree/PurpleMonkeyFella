#pragma once

#include <QObject>
#include <QTimer>

class RandomEvents : public QObject
{
    Q_OBJECT
  public:
    explicit RandomEvents(QObject* parent = nullptr);
    virtual ~RandomEvents();

  signals:
    void newEvent();

  public slots:
    void prepare();

  private:
    QTimer* m_timer;
};
