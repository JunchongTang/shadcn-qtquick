import QtQuick
import QtQuick.Controls.Basic as C

// shadcn InputGroupTextarea —— 置于 InputGroup 内的无边框多行输入(cn-input-group-textarea)。
// 同 InputGroupInput:去掉自身边框/背景/环,py-2 内边距;整组共享边框与统一焦点环。
C.TextArea {
    id: control

    readonly property bool _igControl: true
    readonly property string _igType: "textarea"   // 令 InputGroup 自动切换纵向

    implicitHeight: 64                 // min-h-16
    leftPadding: Theme.space2          // px-2(父组按 addon 覆写)
    rightPadding: Theme.space2
    topPadding: Theme.space2           // py-2
    bottomPadding: Theme.space2
    font.pixelSize: Theme.textXs
    color: Theme.foreground
    placeholderTextColor: Theme.mutedForeground
    selectionColor: Theme.alpha(Theme.primary, 0.35)
    selectedTextColor: Theme.foreground
    wrapMode: TextEdit.Wrap

    background: Item {}
}
