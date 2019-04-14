#include "externalcalls.h"

ExternalCalls* external_call_object = nullptr;

ExternalCalls::ExternalCalls(QObject *parent) : QObject(parent)
{
    external_call_object = this;
}

ExternalCalls::~ExternalCalls()
{
}
