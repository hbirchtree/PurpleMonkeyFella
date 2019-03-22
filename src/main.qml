import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import QtQuick.Window 2.12
import dev.birchy.Purple 1.0

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
        /* I want to get off Mr Bones' Wild Ride */
        monkeyFella.ohLawdHeComin()
    }

    MonkeyFella {
        id: monkeyFella

        onOhLawdHeGone: {
            random.prepare();
        }
    }

    RandomEvents {
        id: random
        interval: 6000
        onNewEvent: {
            /* TODO: Pick random event */

            var anims = [
                        monkeyFella.animSunglasses,
                        monkeyFella.animChuckle,
                        monkeyFella.animMrWorldwide,
                        monkeyFella.animHush,
                        monkeyFella.animGrin,
                    ];

            monkeyFella.playAnimation(
                        anims[random.randRange(0, anims.length - 1)])

            random.interval = random.randRange(5 * 1000, 1 * 60 * 1000)
            console.log("next event in ", interval)
        }
    }

    Dialog {
        id: sayBox
        standardButtons: StandardButton.Ok
        onAccepted: {
            monkeyFella.say(sayTextField.text)
            sayTextField.text = ""
        }

        contentItem: Rectangle {
            TextArea {
                id: sayTextField
                width: parent.width
                height: Screen.pixelDensity * font.pointSize
            }

            Button {
                anchors.top: sayTextField.bottom
                text: "OK"
                width: parent.width
                onClicked: {
                    sayBox.accept()
                }
            }
        }
    }

    MouseArea {
        property point dragPos: Qt.point(0,0)

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if(mouse.button === Qt.RightButton)
                menu.popup()
        }

        /* This stuff is for moving him on Windows and OSX */
        onPressed: {
            if(mouse.button === Qt.LeftButton)
                dragPos = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: {
            var delta = Qt.point(mouse.x - dragPos.x, mouse.y - dragPos.y)
            app.x += delta.x
            app.y += delta.y
        }

        Menu {
            id: menu
            MenuItem {
                text: "Say"
                onClicked: {
                    if(monkeyFella.busy)
                        return;

                    sayBox.open()
                }
            }
            MenuItem {
                text: "Tell me a joke"
                onClicked: {
                    monkeyFella.say("What did the beaver say to the tree?" +
                              " ... Nice gnawing you!")
                }
            }
            MenuItem {
                text: "Say something funny"
                onClicked: {
                    monkeyFella.say("I scoot the burbs")
                }
            }
            MenuItem {
                text: "Tell me something I don't know"
                onClicked: {
                    monkeyFella.say("Grass is green")
                }
            }

            MenuItem {
                text: "Go away"
                onClicked: {
                    monkeyFella.playAnimation(monkeyFella.animSunglasses)
                }
            }
        }
    }
}
