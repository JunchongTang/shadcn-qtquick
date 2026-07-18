import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Input —— 含焦点外圈(focus ring),对标前端 focus-visible:border-ring + ring-[3px]。
C.TextField {
    id: control

    implicitHeight: 28
    leftPadding: Theme.space3
    rightPadding: Theme.space3
    topPadding: 0
    bottomPadding: 0
    font.pixelSize: Theme.textXs
    color: Theme.foreground
    placeholderTextColor: Theme.mutedForeground
    selectionColor: Theme.alpha(Theme.primary, 0.35)
    selectedTextColor: Theme.foreground
    verticalAlignment: TextInput.AlignVCenter

    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        color: "transparent"
        border.width: 1
        border.color: control.activeFocus ? Theme.ring : Theme.border
        Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

        // 焦点外圈:比边框大 ringWidth,半透明 ring 色,聚焦时显示。
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: bg.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.ring, Theme.ringOpacity)
            visible: control.activeFocus
            z: -1
        }
    }
}
