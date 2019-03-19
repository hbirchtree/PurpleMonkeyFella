import QtQuick 2.0
import dev.birchy.Purple 1.0

Image {
    property string variant: "he_cometh"
    property int frameCount: 1139
    property bool busy: true /* He starts off busy, to avoid problems */

    signal ohLawdHeComin()
    signal ohLawdHeGone()

    signal say(string sentence)

    onSay: {
        if(busy)
            return;

        voice.say(sentence)
    }
    onOhLawdHeComin: {
        heCometh.running = true
        heCometh.stopped.connect(ohLawdHeGone)
    }
    onOhLawdHeGone: {
        variant = "keyframes"
        frameCount = 0
        busy = false
    }

    anchors.fill: parent
    onFrameCountChanged: {
        source = "qrc:/monkey_fella/" + variant
                + "/" + ('000' + frameCount).slice(-4) + ".png"
    }

    Speech {
        /* Just our wrapper around QTextToSpeech */
        id: voice

        onStarted: {
            monkeyOverlay.visible = true
            monkeyOverlay.frameCount = 2
            heTalketh.running = true
            busy = true
        }
        onStopped: {
            monkeyOverlay.visible = false
            heTalketh.running = false
            busy = false
        }
    }

    /* Incoming animation on startup */
    SequentialAnimation on frameCount {
        id: heCometh
        running: false
        PropertyAnimation {
            from: 1139
            to: 1164
            duration: 2500
        }
    }

    Image {
        property string variant: "speech"
        property int frameCount: 1

        id: monkeyOverlay
        anchors.fill: parent
        visible: false
        onFrameCountChanged: {
            source = "qrc:/monkey_fella/" + variant
                    + "/" + ('000' + frameCount).slice(-4) + ".png"
        }

        /* Basic talking animation */
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
}
