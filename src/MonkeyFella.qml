import QtQuick 2.0
import dev.birchy.Purple 1.0

Image {
    property string variant: "he_cometh"
    property int frameCount: 1139
    property bool busy: true /* He starts off busy, to avoid problems */

    property SequentialAnimation animSunglasses: sunglasses
    property SequentialAnimation animChuckle: chuckle

    signal ohLawdHeComin()
    signal ohLawdHeGone()
    signal revertLook()
    signal animStart()

    signal say(string sentence)

    onSay: {
        if(busy)
            return;

        voice.say(sentence)
    }

    /* The intro animation */
    onOhLawdHeComin: {
        heCometh.running = true
        heCometh.stopped.connect(ohLawdHeGone)
    }
    onOhLawdHeGone: {
        variant = "keyframes"
        frameCount = 0
        busy = false
    }
    onRevertLook: {
        variant = "keyframes"
        frameCount = 0
        busy = false
        monkeyOverlay.visible = false
    }
    onAnimStart: {
        busy = true
    }

    id: mainImage
    anchors.fill: parent
    onFrameCountChanged: {
        source = "qrc:/monkey_fella/" + variant
                + "/" + ('000' + frameCount).slice(-4) + ".png"
    }

    Speech {
        /* Just our wrapper around QTextToSpeech */
        id: voice

        onStarted: {
            talk.start()
            busy = true
        }
        onStopped: {
            talk.stop()
            monkeyOverlay.visible = false
            busy = false
        }
    }

    /* Incoming animation on startup */
    SequentialAnimation on frameCount {
        id: heCometh
        running: false

        ScriptAction {
            script: animStart()
        }
        PropertyAction {
            target: mainImage; property: ""
        }

        PropertyAnimation {
            from: 1139
            to: 1164
            duration: 2500
        }
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

    /* Basic talking animation */
    SequentialAnimation {
        id: talk
        loops: Animation.Infinite
        running: false

        ScriptAction {
            script: animStart()
        }
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

    /* Just looking cool */
    SequentialAnimation {
        id: sunglasses
        running: false

        ScriptAction {
            script: animStart()
        }
        PropertyAction {
            target: mainImage; property: "variant"
            value: "random/sunglasses"
        }
        PropertyAction {
            target: monkeyOverlay; property: "visible"
            value: true
        }

        PropertyAnimation {
            target: mainImage
            property: "frameCount"
            from: 438
            to: 456
            duration: 1000
        }

        SequentialAnimation {
            loops: 5
            PropertyAction {
                target: mainImage; property: "frameCount"
                value: 458
            }
            PropertyAction {
                target: monkeyOverlay; property: "variant"
                value: "random/sunglasses"
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
        ScriptAction {
            script: revertLook()
        }
    }

    /* Chuckle */
    SequentialAnimation {
        id: chuckle
        running: false

        ScriptAction {
            script: animStart()
        }
        PropertyAction {
            target: mainImage; property: "variant"
            value: "random/chuckle"
        }
        PropertyAnimation {
            target: mainImage
            property: "frameCount"
            from: 1019
            to: 1023
            duration: 400
        }

        SequentialAnimation {
            loops: 10
            PropertyAnimation {
                target: mainImage
                property: "frameCount"
                to: 1022
                duration: 0
            }
            PauseAnimation {
                duration: 100
            }
            PropertyAnimation {
                target: mainImage
                property: "frameCount"
                to: 1023
                duration: 0
            }
            PauseAnimation {
                duration: 100
            }
        }

        PropertyAnimation {
            target: mainImage
            property: "frameCount"
            from: 1023
            to: 1019
            duration: 400
        }

        ScriptAction {
            script: revertLook()
        }
    }
}
