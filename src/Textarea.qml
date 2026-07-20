import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Textarea —— 多行输入,样式与 Input 一致(1px 边框 + 焦点外圈)。
// 文件名 Textarea 与基类 TextArea 大小写不同,无需别名(此处仍用 as C 保持风格统一)。
C.TextArea {
    id: control

    property bool invalid: false   // aria-invalid → 破坏色描边 + 环

    implicitHeight: 64             // min-h-16
    leftPadding: Theme.space2      // px-2
    rightPadding: Theme.space2
    topPadding: Theme.space2       // py-2
    bottomPadding: Theme.space2
    font.pixelSize: Theme.textXs
    color: Theme.foreground
    placeholderTextColor: Theme.mutedForeground
    selectionColor: Theme.alpha(Theme.primary, 0.35)
    selectedTextColor: Theme.foreground
    wrapMode: TextEdit.Wrap

    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        color: Theme.alpha(Theme.input, 0.2)      // bg-input/20 微填充
        border.width: 1
        border.color: control.invalid ? Theme.destructive
                     : control.activeFocus ? Theme.ring : Theme.border
        Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid 破坏色环
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: bg.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.destructive, 0.2)
            visible: control.invalid
            z: -1
        }

        FocusRing { active: control.activeFocus; targetRadius: bg.radius }
    }
}
