import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import dev.birchy.Speech 1.0

Window {
    id: app
    flags: Qt.ToolTip | Qt.FramelessWindowHint | Qt.WA_TranslucentBackground

    color: "#00000000"

    visible: true
    width: 400
    height: 320
    title: qsTr("Not a Bonzi Revolution")

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

        onFrameCountChanged: {
            source = "qrc:/monkey_fella/speech/"
                    + ('000' + frameCount).slice(-4) + ".png"

            voice.say("derp")
        }

        SequentialAnimation on frameCount {
            loops: Animation.Infinite
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
                text: "Go away"
                onClicked: {
                    app.close()
                }
            }
        }
    }

}
