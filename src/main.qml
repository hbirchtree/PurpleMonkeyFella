import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

import QtQuick.Dialogs

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

    MonkeyFella {
        id: monkeyFella
        anchors.fill: parent
    }

    Timer {
        id: flyIn
        interval: 200
        onTriggered: {
            monkeyFella.state = "heCometh";
        }
    }
    Timer {
        id: openerLine
        interval: 2500
        onTriggered: {
            monkeyFella.say("Hello expand dong, I cum and piss, now I'm a roflcopter, soisoisoisoisoisoi");
        }
    }
    onTitleChanged: {
        flyIn.start();
        openerLine.start();
    }

    ExternalCalls {
        id: derp

        onExternalEvent: {
            console.log(command)

            switch(command.substring(0, 1))
            {
            case 's':
                monkeyFella.startTalking(command.substring(1, 100))
                break;
            case 'e':
                monkeyFella.stopTalking()
                break;
            case 'r':
                console.log("switching RandomEvents state")
                switch(command.substring(1))
                {
                case 'start':
                    random.prepare();
                    break;
                case 'stop':
                    random.stop();
                    break;
                default:
                    break;
                }
                break;
            default:
                console.log("Unhandled command: " + command.substring(1))
                break;
            }
        }
    }

    RandomEvents {
        id: random
        interval: 6000
        onNewEvent: {
            if (monkeyFella.state !== "")
                return;

            var anims = [
                        "grinning",
                        "blinking",
                        "doubleBlink",
                        "sunglasses",
                        "chuckle",
                        "hushing",
                        "mrWorldwide",
                    ];

            monkeyFella.state = anims[random.randRange(0, anims.length - 1)];

            random.interval = random.randRange(5000, 5000);
            console.log("next event in ", interval);
        }
    }

    Dialog {
        id: sayBox
//        standardButtons: StandardButton.Ok
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

        width: 150
        x: (parent.width - width) / 2
        height: parent.height
        y: 0

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
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
                    monkeyFella.say("What did the beaver say to the tree." +
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
