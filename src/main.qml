import QtQuick 2.12
import QtQuick.Controls 2.5
import dev.birchy.Speech 1.0
import QtQuick.Window 2.12

Window {
    id: app
    flags: Qt.ToolTip
           | Qt.FramelessWindowHint
           | Qt.WA_TranslucentBackground
           | Qt.WindowStaysOnTopHint

    color: "#00000000"

    visible: true
    width: 400
    height: 320
    title: qsTr("Not a Bonzi Revolution")

    onTitleChanged: {
        heCometh.stopped.connect(function() {
            monkeyFella.variant = "keyframes"
            monkeyFella.frameCount = 0

            monkeyOverlay.visible = true
        })

        voice.started.connect(function() {
            monkeyOverlay.visible = true
            monkeyOverlay.frameCount = 3
            heTalketh.running = true
        })

        voice.stopped.connect(function() {
            monkeyOverlay.visible = false
            heTalketh.running = false
        })

        heCometh.start()
    }

    Speech {
        id: voice
    }

    Image {
        property string variant: "he_cometh"
        property int frameCount: 1139

        id: monkeyFella
        anchors.fill: parent

        onFrameCountChanged: {
            source = "qrc:/monkey_fella/" + variant
                    + "/" + ('000' + frameCount).slice(-4) + ".png"
        }
        SequentialAnimation on frameCount {
            id: heCometh
            running: false
            PropertyAnimation {
                from: 1139
                to: 1164
                duration: 2500
            }
        }
    }

    Image {
        property string variant: "speech"
        property int frameCount: 1

        id: monkeyOverlay
        anchors.fill: parent
        visible: false

        onFrameCountChanged: {
            source = "qrc:/monkey_fella/speech/"
                    + ('000' + frameCount).slice(-4) + ".png"
        }

        SequentialAnimation on frameCount {
            id: heTalketh
            loops: Animation.Infinite
            running: false
            PropertyAnimation {
                from: 1
                to: 7
                duration: 1000
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: {
            menu.popup()
        }

        Menu {
            id: menu
            MenuItem {
                text: "Tell me a joke"
                onClicked: {
                    voice.say("What did the beaver say to the tree?" +
                              " ... Nice gnawing you!")
                }
            }
            MenuItem {
                text: "Go away"
                onClicked: {
                    app.close()
                }
            }
        }
    }
}
