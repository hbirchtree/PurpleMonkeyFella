#pragma once

#include <QObject>

class ExternalCalls : public QObject
{
    Q_OBJECT
  public:
    explicit ExternalCalls(QObject* parent = nullptr);
    virtual ~ExternalCalls();

  signals:
    void externalEvent(QString const& command);

  public slots:
};

extern ExternalCalls* external_call_object;
