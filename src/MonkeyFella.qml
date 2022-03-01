import QtQuick 2.0
import dev.birchy.Purple 1.0

Image {
    id: root
    state: "absent"
    source: "qrc:/monkey_fella/" + variant + "/" + ("000" + frameCount).slice(-4) + ".png"

    onStateChanged: {
        console.log("state -> " + state);
    }

    property string variant: "he_cometh"
    property int frameCount: 1139
    property bool busy: true /* He starts off busy, to avoid problems */

    property var mainStack: []
    property var overlayStack: []

    function pushMain(newVariant) {
        mainStack.push(variant);
        variant = newVariant;
    }
    function popMain() {
        variant = mainStack.pop();
    }
    function pushOverlay(newOverlay) {
        overlayStack.push(monkeyOverlay.variant);
        monkeyOverlay.variant = newOverlay;
    }
    function popOverlay() {
        monkeyOverlay.variant = overlayStack.pop();
    }

    signal say(string sentence)
    onSay: (sentence) => {
        voice.say(sentence);
    }

    Speech {
        /* Just our wrapper around QTextToSpeech */
        id: voice
    }

    Image {
        property string variant: ""
        property int frameCount: 0

        id: monkeyOverlay
        anchors.fill: parent
        visible: false
        onFrameCountChanged: {
            source = "qrc:/monkey_fella/" + variant
                    + "/" + ('000' + frameCount).slice(-4) + ".png"
        }
    }

    states: [
        State {
            name: "absent"
        },
        State {
            name: "heCometh"
            changes: [
                PropertyChanges {
                    target: root
                    frameCount: 1139
                },
                PropertyChanges {
                    target: root
                    variant: "he_cometh"
                }
            ]
        },
        State {
            name: ""
            changes: [
                PropertyChanges {
                    target: root
                    frameCount: 0
                },
                PropertyChanges {
                    target: root
                    variant: "keyframes"
                }
            ]
        },
        State {
            name: "speaking"
            when: voice.running
            changes: [
                PropertyChanges {
                    target: talk
                    running: true
                },
                PropertyChanges {
                    target: monkeyOverlay
                    variant: "speech"
                },
                PropertyChanges {
                    target: monkeyOverlay
                    frameCount: 2
                }
            ]
        },
        State {
            name: "blinking"
            changes: [
                PropertyChanges {
                    target: monkeyOverlay
                    visible: true
                },
                PropertyChanges {
                    target: monkeyOverlay
                    variant: "blinking/regular"
                },
                PropertyChanges {
                    target: monkeyOverlay
                    frameCount: 26
                }
            ]
        },
        State {
            name: "doubleBlink"
            changes: [
                PropertyChanges {
                    target: monkeyOverlay
                    visible: true
                },
                PropertyChanges {
                    target: monkeyOverlay
                    variant: "blinking/regular"
                },
                PropertyChanges {
                    target: monkeyOverlay
                    frameCount: 26
                }
            ]
        },
        State {
            name: "grinning"
            changes: [
                PropertyChanges {
                    target: root
                    frameCount: 1073
                },
                PropertyChanges {
                    target: root
                    variant: "random/grin"
                },
                PropertyChanges {
                    target: monkeyOverlay
                    visible: true
                },
                PropertyChanges {
                    target: monkeyOverlay
                    variant: "random/grin"
                },
                PropertyChanges {
                    target: monkeyOverlay
                    frameCount: 1076
                }
            ]
        },
        State {
            name: "sunglasses"
            changes: [
                PropertyChanges {
                    target: root
                    frameCount: 438
                },
                PropertyChanges {
                    target: root
                    variant: "random/sunglasses"
                },
                PropertyChanges {
                    target: monkeyOverlay
                    visible: true
                },
                PropertyChanges {
                    target: monkeyOverlay
                    variant: "random/sunglasses"
                },
                PropertyChanges {
                    target: monkeyOverlay
                    frameCount: 457
                }
            ]
        },
        State {
            name: "chuckle"
            changes: [
                PropertyChanges {
                    target: root
                    frameCount: 1019
                },
                PropertyChanges {
                    target: root
                    variant: "random/chuckle"
                }
            ]
        },
        State {
            name: "hushing"
            changes: [
                PropertyChanges {
                    target: root
                    frameCount: 1110
                },
                PropertyChanges {
                    target: root
                    variant: "random/hushing"
                }
            ]
        },
        State {
            name: "mrWorldwide"
            changes: [
                PropertyChanges {
                    target: root
                    frameCount: 260
                },
                PropertyChanges {
                    target: root
                    variant: "random/mr_worldwide"
                },
                PropertyChanges {
                    target: monkeyOverlay
                    visible: true
                },
                PropertyChanges {
                    target: monkeyOverlay
                    variant: "random/mr_worldwide/world"
                },
                PropertyChanges {
                    target: monkeyOverlay
                    frameCount: 0
                }
            ]
        }
    ]
    transitions: [
        Transition {
            /* Incoming animation on startup */
            from: "absent"
            to: "heCometh"
            animations: [
                SequentialAnimation {
                    PropertyAction {
                        target: root; property: "variant"
                        value: "he_cometh"
                    }
                    PropertyAction {
                        target: root; property: "frameCount"
                        value: 1139
                    }
                    NumberAnimation {
                        target: root
                        property: "frameCount"
                        from: 1139
                        to: 1164
                        duration: 2500
                    }
                    PropertyAction {
                        target: root; property: "state"
                        value: ""
                    }
                }
            ]
        },
        Transition {
            to: "blinking"
            animations: [
                SequentialAnimation {
                    PropertyAction {
                        target: monkeyOverlay; property: "frameCount"
                        value: 26
                    }
                    PauseAnimation {
                        duration: 200
                    }
                    PropertyAction {
                        target: monkeyOverlay; property: "frameCount"
                        value: 27
                    }
                    PauseAnimation {
                        duration: 200
                    }
                    PropertyAction {
                        target: monkeyOverlay; property: "frameCount"
                        value: 26
                    }
                    PauseAnimation {
                        duration: 200
                    }
                    PropertyAction {
                        target: root; property: "state"
                        value: ""
                    }
                }
            ]
        },
        Transition {
            to: "doubleBlink"
            animations: [
                SequentialAnimation {
                    PropertyAction {
                        target: monkeyOverlay; property: "frameCount"
                        value: 26
                    }
                    PauseAnimation {
                        duration: 200
                    }
                    PropertyAction {
                        target: monkeyOverlay; property: "frameCount"
                        value: 27
                    }
                    PauseAnimation {
                        duration: 200
                    }
                    PropertyAction {
                        target: monkeyOverlay; property: "frameCount"
                        value: 26
                    }
                    PauseAnimation {
                        duration: 200
                    }
                    PropertyAction {
                        target: monkeyOverlay; property: "frameCount"
                        value: 27
                    }
                    PauseAnimation {
                        duration: 200
                    }
                    PropertyAction {
                        target: monkeyOverlay; property: "frameCount"
                        value: 26
                    }
                    PauseAnimation {
                        duration: 200
                    }
                    PropertyAction {
                        target: root; property: "state"
                        value: ""
                    }
                }
            ]
        },
        Transition {
            to: "grinning"
            animations: [
                SequentialAnimation {
                    /* Opening his mouth */
                    PropertyAnimation {
                        target: root
                        property: "frameCount"
                        from: 1073
                        to: 1075
                        duration: 500
                    }

                    /* The sparkle */
                    SequentialAnimation {
                        PropertyAnimation {
                            target: monkeyOverlay
                            property: "frameCount"
                            from: 1076
                            to: 1082
                            duration: 600
                        }
                        PropertyAnimation {
                            target: monkeyOverlay
                            property: "frameCount"
                            from: 1082
                            to: 1076
                            duration: 600
                        }
                    }

                    /* Closing his mouth */
                    PropertyAnimation {
                        target: root
                        property: "frameCount"
                        from: 1075
                        to: 1073
                        duration: 500
                    }
                    PropertyAction {
                        target: root; property: "state"
                        value: ""
                    }
                }
            ]
        },
        Transition {
            to: "sunglasses"
            animations: [
                SequentialAnimation {
                    PropertyAnimation {
                        target: root
                        property: "frameCount"
                        from: 438
                        to: 456
                        duration: 1000
                    }

                    SequentialAnimation {
                        loops: 5
                        PropertyAction {
                            target: root; property: "frameCount"
                            value: 458
                        }
                        PropertyAction {
                            target: monkeyOverlay; property: "visible"
                            value: true
                        }

                        /* Dramatic pause */
                        PropertyAction {
                            target: monkeyOverlay; property: "frameCount"
                            value: 457
                        }
                        PauseAnimation {
                            duration: 2000
                        }

                        /* Start swinging head right */
                        PropertyAnimation {
                            target: monkeyOverlay
                            property: "frameCount"
                            from: 459
                            to: 460
                            duration: 400
                        }
                        PauseAnimation {
                            duration: 1000
                        }
                        PropertyAnimation {
                            target: monkeyOverlay
                            property: "frameCount"
                            to: 461
                            duration: 400
                        }
                        PropertyAnimation {
                            target: monkeyOverlay
                            property: "frameCount"
                            to: 459
                            duration: 400
                        }
                        PropertyAction {
                            target: monkeyOverlay; property: "frameCount"
                            value: 457
                        }
                        PauseAnimation {
                            duration: 400
                        }

                        /* Start swinging head right */
                        PropertyAnimation {
                            target: monkeyOverlay
                            property: "frameCount"
                            from: 462
                            to: 465
                            duration: 400
                        }
                        PauseAnimation {
                            duration: 1000
                        }
                        PropertyAnimation {
                            target: monkeyOverlay
                            property: "frameCount"
                            from: 465
                            to: 462
                            duration: 400
                        }
                    }
                    PropertyAnimation {
                        target: monkeyOverlay
                        property: "frameCount"
                        from: 456
                        to: 438
                        duration: 1000
                    }
                    PropertyAction {
                        target: root; property: "state"
                        value: ""
                    }
                }
            ]
        },
        Transition {
            to: "chuckle"
            animations: [
                SequentialAnimation {
                    PropertyAnimation {
                        target: root
                        property: "frameCount"
                        from: 1019
                        to: 1023
                        duration: 400
                    }

                    SequentialAnimation {
                        loops: 10
                        PropertyAnimation {
                            target: root
                            property: "frameCount"
                            to: 1022
                            duration: 0
                        }
                        PauseAnimation {
                            duration: 100
                        }
                        PropertyAnimation {
                            target: root
                            property: "frameCount"
                            to: 1023
                            duration: 0
                        }
                        PauseAnimation {
                            duration: 100
                        }
                    }

                    PropertyAnimation {
                        target: root
                        property: "frameCount"
                        from: 1023
                        to: 1019
                        duration: 400
                    }
                    PropertyAction {
                        target: root; property: "state"
                        value: ""
                    }
                }
            ]
        },
        Transition {
            to: "hushing"
            animations: [
                SequentialAnimation {
                    /* Lean in... */
                    PropertyAnimation {
                        target: root
                        property: "frameCount"
                        from: 1110
                        to: 1114
                        duration: 500
                    }

                    /* Now you listen here... */
                    PauseAnimation {
                        duration: 1000
                    }

                    /* Nah jk */
                    PropertyAnimation {
                        target: root
                        property: "frameCount"
                        from: 1114
                        to: 1110
                        duration: 500
                    }
                    PropertyAction {
                        target: root; property: "state"
                        value: ""
                    }
                }
            ]
        },
        Transition {
            to: "mrWorldwide"
            animations: [
                SequentialAnimation {
                    /* Pick up the world */
                    PropertyAction {
                        target: root; property: "variant"
                        value: "random/mr_worldwide"
                    }
                    PropertyAnimation {
                        target: root
                        property: "frameCount"
                        from: 260
                        to: 264
                        duration: 500
                    }

                    /* Setup for spinning the world */
                    PropertyAction {
                        target: root; property: "variant"
                        value: "random/mr_worldwide/looking"
                    }
                    PropertyAction {
                        target: root; property: "frameCount"
                        value: 0
                    }
                    PropertyAction {
                        target: monkeyOverlay; property: "variant"
                        value: "random/mr_worldwide/world"
                    }
                    PropertyAction {
                        target: monkeyOverlay; property: "frameCount"
                        value: 0
                    }

                    /* Say it */
//                    ScriptAction {
//                        script: say("Mr Worldwide")
//                    }

                    /* Let it spin */
                    ParallelAnimation {
                        loops: 10

                        PropertyAnimation {
                            target: root
                            property: "frameCount"
                            from: 0
                            to: 7
                            duration: 2000
                        }
                        PropertyAnimation {
                            target: monkeyOverlay
                            property: "frameCount"
                            from: 0
                            to: 23
                            duration: 2000
                        }
                    }

                    /* Put it down */
                    PropertyAction {
                        target: root; property: "variant"
                        value: "random/mr_worldwide"
                    }
                    PropertyAnimation {
                        target: root
                        property: "frameCount"
                        from: 264
                        to: 260
                        duration: 500
                    }
                    PropertyAction {
                        target: root; property: "state"
                        value: ""
                    }
                }
            ]
        }
    ]

    /* Blinking while idle */


    /* Basic talking animation */
    SequentialAnimation {
        id: talk
        loops: Animation.Infinite
        running: false

        PropertyAction {
            target: monkeyOverlay; property: "visible"
            value: true
        }
        PropertyAction {
            target: monkeyOverlay; property: "variant"
            value: "speech"
        }
        PropertyAnimation {
            target: monkeyOverlay
            property: "frameCount"
            from: 2
            to: 7
            duration: 1000
        }
    }
}
