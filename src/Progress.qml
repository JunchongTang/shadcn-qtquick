import QtQuick

// shadcn Progress(base-mira) —— h-1 轨道(bg-muted)+ primary 指示条。value 取 0..100。
Item {
    id: control

    property real value: 0

    implicitWidth: 200
    implicitHeight: 4              // h-1

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusMd
        color: Theme.muted
        clip: true

        Rectangle {
            height: parent.height
            width: parent.width * Math.max(0, Math.min(100, control.value)) / 100
            radius: Theme.radiusMd
            color: Theme.primary
            Behavior on width { NumberAnimation { duration: Theme.durBase; easing.type: Easing.OutCubic } }
        }
    }
}
