#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "externalcalls.h"
#include "randomevents.h"
#include "speech.h"

#if defined(Q_OS_WASM)
#include <emscripten/bind.h>

using namespace emscripten;

int external_event(std::string command)
{
    if(!external_call_object)
        return -1;

    external_call_object->externalEvent(command.c_str());
    return 0;
}

EMSCRIPTEN_BINDINGS(external_events)
{
    function("push_event", &external_event);
}
#endif

int main(int argc, char* argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<Speech>("dev.birchy.Purple", 1, 0, "Speech");
    qmlRegisterType<RandomEvents>("dev.birchy.Purple", 1, 0, "RandomEvents");
    qmlRegisterType<ExternalCalls>("dev.birchy.Purple", 1, 0, "ExternalCalls");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if(engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
