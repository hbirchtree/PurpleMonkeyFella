cmake_minimum_required(VERSION 3.1)

project(PurpleMonkeyFella LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS Core Quick QuickControls2 Qml REQUIRED)
find_package(Qt6QmlImportScanner REQUIRED)

find_package(Qt6 COMPONENTS Multimedia)

add_executable ( ${PROJECT_NAME}
    src/main.cpp
    src/qml.qrc
    src/randomevents.cpp
    src/externalcalls.cpp
    )
target_compile_definitions ( ${PROJECT_NAME} PRIVATE
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
    )
target_link_libraries ( ${PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
    Qt6::QuickControls2
    )

qt6_import_qml_plugins(${PROJECT_NAME})

if(TARGET Qt6::Multimedia)
    target_sources ( ${PROJECT_NAME} PRIVATE
        src/speech.cpp
        )
    target_link_libraries ( ${PROJECT_NAME} PRIVATE
        Qt6::Multimedia
        )
    target_compile_definitions ( ${PROJECT_NAME} PRIVATE
        -DPURPLE_AUDIOOUT
        )
else()
    target_compile_definitions ( ${PROJECT_NAME} PRIVATE
        -DPURPLE_NO_MEDIA
        )
endif()
