import QtQuick
import QtQuick.Controls.Basic as C
import LucideIcons

// shadcn Checkbox —— 16px 指示块 + Lucide check 图标 + 可选右侧文字。
// 文件名 Checkbox 与基类 CheckBox 大小写不同,无需别名。
C.CheckBox {
    id: control

    property bool invalid: false        // aria-invalid → 破坏色描边 + 环

    spacing: Theme.space2
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // 键盘可 Tab 聚焦(Space/Enter 触发由 AbstractButton 自带)
    font.pixelSize: Theme.textSm
    opacity: enabled ? 1.0 : 0.5

    indicator: Rectangle {
        id: box
        implicitWidth: 16               // size-4
        implicitHeight: 16
        x: 0
        y: (control.height - height) / 2
        radius: 4                        // rounded-[4px](mira 固定值)
        // 未选中:亮色透明,暗色 bg-input/30。
        color: control.checked ? Theme.primary
                               : (Theme.dark ? Theme.alpha(Theme.input, 0.3) : Theme.alpha(Theme.primary, 0))
        border.width: 1
        // aria-invalid:aria-checked:border-primary —— 选中时即便 invalid 仍用 primary。
        border.color: control.checked ? Theme.primary
                     : control.invalid ? Theme.destructive
                     : Theme.input
        Behavior on color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid 破坏色环
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: box.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.destructive, 0.2)
            visible: control.invalid
            z: -1
        }

        // 勾选图标。
        LucideIcon {
            anchors.centerIn: parent
            name: "check"
            size: 14                     // svg size-3.5
            color: Theme.primaryForeground
            visible: control.checked
        }

        FocusRing { active: control.visualFocus; targetRadius: box.radius }
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
