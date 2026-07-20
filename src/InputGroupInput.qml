import QtQuick
import QtQuick.Controls.Basic as C

// shadcn InputGroupInput —— 置于 InputGroup 内的无边框单行输入(cn-input-group-input)。
// 去掉 Input 自身的边框/背景/焦点环:整组共享一个圆角边框与统一焦点环由 InputGroup 提供。
// _igControl / _igType 供 InputGroup 分拣定位与内边距计算;内边距由父组按 addon 存在情况覆写。
C.TextField {
    id: control

    readonly property bool _igControl: true      // InputGroup 识别为「控件」
    readonly property string _igType: "input"    // 用于自动判定横/纵向

    implicitHeight: 28                 // h-7(与组同高)
    leftPadding: Theme.space2          // px-2(父组按 addon 覆写为 pl-1.5)
    rightPadding: Theme.space2
    topPadding: 0
    bottomPadding: 0
    font.pixelSize: Theme.textXs
    color: Theme.foreground
    placeholderTextColor: Theme.mutedForeground
    selectionColor: Theme.alpha(Theme.primary, 0.35)
    selectedTextColor: Theme.foreground
    verticalAlignment: TextInput.AlignVCenter

    // 透明、无边框、无焦点环 —— 视觉边框/环由 InputGroup 统一提供。
    background: Item {}
}
