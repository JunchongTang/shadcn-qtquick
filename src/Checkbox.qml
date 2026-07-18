import QtQuick
import QtQuick.Controls.Basic as C
import LucideIcons

// shadcn Checkbox —— 16px 指示块 + Lucide check 图标 + 可选右侧文字。
// 文件名 Checkbox 与基类 CheckBox 大小写不同,无需别名。
C.CheckBox {
    id: control

    spacing: Theme.space2
    hoverEnabled: true
    font.pixelSize: Theme.textSm
    opacity: enabled ? 1.0 : 0.5

    indicator: Rectangle {
        id: box
        implicitWidth: 16
        implicitHeight: 16
        x: 0
        y: (control.height - height) / 2
        radius: Theme.radiusSm
        color: control.checked ? Theme.primary : "transparent"
        border.width: 1
        border.color: control.checked ? Theme.primary : Theme.border
        Behavior on color { ColorAnimation { duration: Theme.durFast } }

        // 勾选图标。
        LucideIcon {
            anchors.centerIn: parent
            name: "check"
            size: 12
            color: Theme.primaryForeground
            visible: control.checked
        }

        // 焦点外圈,复用 Input 的焦点环模式。
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: box.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.ring, Theme.ringOpacity)
            visible: control.activeFocus
            z: -1
        }
    }

    contentItem: Text {
        text: control.text
        visible: control.text.length > 0
        leftPadding: control.indicator.width + control.spacing
        font: control.font
        color: Theme.foreground
        verticalAlignment: Text.AlignVCenter
    }
}
