import QtQuick
import QtQuick.Controls.Basic as C

// shadcn RadioGroupItem(base-mira) —— size-4 圆形,选中填 primary + primary-foreground 内点。
// 同一父级内 autoExclusive 默认为真,天然互斥;或放入 RadioGroup。
C.RadioButton {
    id: control

    property bool invalid: false     // aria-invalid → 破坏色描边 + 环

    spacing: Theme.space2
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // 键盘可 Tab 聚焦(Space/Enter 触发由 AbstractButton 自带)
    font.pixelSize: Theme.textXs
    opacity: enabled ? 1.0 : 0.5

    indicator: Rectangle {
        id: circle
        implicitWidth: 16                // size-4
        implicitHeight: 16
        x: 0
        y: (control.height - height) / 2
        radius: 8
        color: control.checked ? Theme.primary : Theme.alpha(Theme.primary, 0)
        border.width: 1
        border.color: control.invalid ? Theme.destructive
                     : control.checked ? Theme.primary : Theme.input
        Behavior on color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid 破坏色环
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: circle.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.destructive, 0.2)
            visible: control.invalid
            z: -1
        }

        Rectangle {
            anchors.centerIn: parent
            width: 8                     // size-2 内点
            height: 8
            radius: 4
            color: Theme.primaryForeground
            visible: control.checked
        }

        FocusRing { active: control.visualFocus; targetRadius: circle.radius }
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
