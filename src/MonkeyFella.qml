import QtQuick 2.0
import dev.birchy.Purple 1.0

Image {
    property string variant: "he_cometh"
    property int frameCount: 1139
    property bool busy: true /* He starts off busy, to avoid problems */

    property Animation animSunglasses: sunglasses
    property Animation animChuckle: chuckle
    property Animation animMrWorldwide: worldwide
    property Animation animHush: hushing
    property Animation animGrin: grin

    signal playAnimation(Animation anim)

    signal ohLawdHeComin()
    signal ohLawdHeGone()

    signal animStart()
    signal revertLook()

    signal say(string sentence)

    signal startTalking(string sentence)
    signal stopTalking()

    onStartTalking: {
        playAnimation(talk)
    }
    onStopTalking: {
        if(talk.running) {
            talk.stop()
            revertLook()
        }
    }

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
        revertLook()
    }
    onAnimStart: {
        monkeyOverlay.visible = false
        blink.stop()
    }
    onRevertLook: {
        variant = "keyframes"
        frameCount = 0
        busy = false
        monkeyOverlay.visible = false

        blink.start()
    }
    onPlayAnimation: {
        if(busy)
            return;
        busy = true

        console.log("starting animation")

        anim.start()
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
            playAnimation(talk)
        }
        onStopped: {
            if(talk.running)
            {
                talk.stop()
                revertLook()
            }
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

    /* Blinking while idle */
    SequentialAnimation {
        id: blink
        loops: Animation.Infinite
        running: false

        PropertyAction {
            target: monkeyOverlay; property: "visible"
            value: true
        }
        PropertyAction {
            target: monkeyOverlay; property: "variant"
            value: "blinking/regular"
        }

        PropertyAction {
            target: monkeyOverlay; property: "frameCount"
            value: 26
        }
        PauseAnimation {
            duration: 100
        }
        PropertyAction {
            target: monkeyOverlay; property: "frameCount"
            value: 27
        }
        PauseAnimation {
            duration: 100
        }
        PropertyAction {
            target: monkeyOverlay; property: "frameCount"
            value: 26
        }
        PauseAnimation {
            duration: 100
        }

        ScriptAction {
            script: revertLook()
        }

        PauseAnimation {
            duration: 5000
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
        ScriptAction {
            script: revertLook()
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

    /* Mr Worldwide */
    SequentialAnimation {
        id: worldwide
        running: false

        ScriptAction {
            script: animStart()
        }

        PropertyAction {
            target: mainImage; property: "variant"
            value: "random/mr_worldwide"
        }

        /* Pick up the world */
        PropertyAnimation {
            target: mainImage
            property: "frameCount"
            from: 260
            to: 264
            duration: 500
        }

        /* Setup for spinning the world */
        PropertyAction {
            target: mainImage; property: "variant"
            value: "random/mr_worldwide/looking"
        }
        PropertyAction {
            target: monkeyOverlay; property: "variant"
            value: "random/mr_worldwide/world"
        }
        PropertyAction {
            target: mainImage; property: "frameCount"
            value: 0
        }
        PropertyAction {
            target: monkeyOverlay; property: "frameCount"
            value: 0
        }
        PropertyAction {
            target: monkeyOverlay; property: "visible"
            value: true
        }

        /* Say it */
        ScriptAction {
            script: say("Mr Worldwide")
        }

        /* Let it spin */
        ParallelAnimation {
            loops: 10

            PropertyAnimation {
                target: mainImage
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

        /* Hide the globe */
        PropertyAction {
            target: monkeyOverlay; property: "visible"
            value: false
        }

        /* Put it down */
        PropertyAction {
            target: mainImage; property: "variant"
            value: "random/mr_worldwide"
        }
        PropertyAnimation {
            target: mainImage
            property: "frameCount"
            from: 264
            to: 260
            duration: 500
        }

        ScriptAction {
            script: revertLook()
        }
    }

    /* Hushing (wait what?) */
    SequentialAnimation {
        id: hushing
        running: false

        ScriptAction {
            script: animStart()
        }

        PropertyAction {
            target: mainImage; property: "variant"
            value: "random/hushing"
        }

        /* Lean in... */
        PropertyAnimation {
            target: mainImage
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
            target: mainImage
            property: "frameCount"
            from: 1114
            to: 1110
            duration: 500
        }

        ScriptAction {
            script: revertLook()
        }
    }

    /* Normal grin */
    SequentialAnimation {
        id: grin
        running: false

        ScriptAction {
            script: animStart()
        }

        PropertyAction {
            target: mainImage; property: "variant"
            value: "random/grin"
        }

        /* Opening his mouth */
        PropertyAnimation {
            target: mainImage
            property: "frameCount"
            from: 1073
            to: 1075
            duration: 500
        }

        /* The sparkle */
        SequentialAnimation {
            PropertyAction {
                target: monkeyOverlay; property: "variant"
                value: "random/grin"
            }
            PropertyAction {
                target: monkeyOverlay; property: "visible"
                value: true
            }

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
            PropertyAction {
                target: monkeyOverlay; property: "visible"
                value: false
            }
        }

        /* Closing his mouth */
        PropertyAnimation {
            target: mainImage
            property: "frameCount"
            from: 1075
            to: 1073
            duration: 500
        }

        ScriptAction {
            script: revertLook()
        }
    }
}
