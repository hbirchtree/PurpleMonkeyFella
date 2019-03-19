#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "speech.h"
#include "randomevents.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<Speech>("dev.birchy.Purple", 1, 0, "Speech");
    qmlRegisterType<RandomEvents>("dev.birchy.Purple", 1, 0, "RandomEvents");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
