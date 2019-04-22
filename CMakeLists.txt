cmake_minimum_required(VERSION 3.1)

project(PurpleMonkeyFella LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Quick Multimedia REQUIRED)

add_executable ( ${PROJECT_NAME}
    src/main.cpp
    src/qml.qrc
    src/speech.cpp
    src/randomevents.cpp
    src/externalcalls.cpp
    )

target_compile_definitions ( ${PROJECT_NAME} PRIVATE
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
    )

set_property ( TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 14 )

target_link_libraries ( ${PROJECT_NAME} PRIVATE
    Qt5::Core
    Qt5::Quick
    Qt5::Multimedia
    )
