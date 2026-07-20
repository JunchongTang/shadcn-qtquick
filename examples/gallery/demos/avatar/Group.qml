import QtQuick
import Shadcn

// 重叠头像组:每个头像带 background 色描边环,向左重叠。
Item {
    readonly property int step: 24
    readonly property var people: [
        { src: "https://github.com/shadcn.png", fb: "CN" },
        { src: "https://github.com/maxleiter.png", fb: "LR" },
        { src: "https://github.com/evilrabbit.png", fb: "ER" }
    ]
    implicitHeight: 36
    implicitWidth: 36 + (people.length - 1) * step

    Repeater {
        model: parent.people
        delegate: Rectangle {
            required property int index
            required property var modelData
            x: index * 24
            z: 10 - index
            width: 36; height: 36; radius: 18
            color: Theme.background      // ring-background
            Avatar {
                anchors.centerIn: parent
                source: modelData.src
                fallback: modelData.fb
            }
        }
    }
}
