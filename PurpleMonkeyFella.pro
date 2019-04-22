TEMPLATE = app

QT += quick multimedia network
CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS PURPLE_NO_NETWORK PURPLE_NO_MEDIA
#  PURPLE_NO_MEDIA PURPLE_NO_NETWORK

SOURCES += src/main.cpp src/speech.cpp src/randomevents.cpp \
    src/externalcalls.cpp
HEADERS += src/speech.h src/randomevents.h \
    src/externalcalls.h

RESOURCES += src/qml.qrc

QML_IMPORT_PATH =

QML_DESIGNER_IMPORT_PATH =

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
