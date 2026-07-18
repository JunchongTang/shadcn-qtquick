import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Textarea —— 多行输入,样式与 Input 一致(1px 边框 + 焦点外圈)。
// 文件名 Textarea 与基类 TextArea 大小写不同,无需别名(此处仍用 as C 保持风格统一)。
C.TextArea {
    id: control

    implicitHeight: 64 // min-h-16
    leftPadding: Theme.space3
    rightPadding: Theme.space3
    topPadding: Theme.space2
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
