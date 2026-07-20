import QtQuick

// shadcn DropdownMenuLabel —— muted 小标题(px-2 py-1.5 text-xs text-muted-foreground)。
// 用纯 Item 而非 MenuItem:不可交互,键盘导航自动跳过。
Item {
    id: control

    property string text: ""
    property bool inset: false       // data-inset:pl-7.5

    implicitWidth: label.x + label.implicitWidth + Theme.space2
    implicitHeight: label.implicitHeight + Theme.space1_5 * 2   // py-1.5

    Text {
        id: label
        x: control.inset ? 30 : Theme.space2                    // pl-7.5(30px) 或 px-2
        y: Theme.space1_5
        text: control.text
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
    }
}
