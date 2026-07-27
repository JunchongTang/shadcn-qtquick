import QtQuick
import Shadcn

// Overlapping avatar group + trailing count (+N).
Item {
    readonly property int step: 24
    readonly property var people: [
        { src: "https://github.com/shadcn.png", fb: "CN" },
        { src: "https://github.com/maxleiter.png", fb: "LR" },
        { src: "https://github.com/evilrabbit.png", fb: "ER" }
    ]
    implicitHeight: 36
    implicitWidth: 36 + people.length * step

    Repeater {
        model: parent.people
        delegate: Rectangle {
            required property int index
            required property var modelData
            x: index * 24
            z: 10 - index
            width: 36; height: 36; radius: 18
            color: Theme.background
            Avatar {
                anchors.centerIn: parent
                source: modelData.src
                fallback: modelData.fb
            }
        }
    }

    Rectangle {
        x: 3 * 24
        z: 0
        width: 36; height: 36; radius: 18
        color: Theme.background
        Rectangle {
            anchors.centerIn: parent
            width: 32; height: 32; radius: 16
            color: Theme.muted
            Text {
                anchors.centerIn: parent
                text: "+3"
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                font.weight: Font.Medium
            }
        }
    }
}
