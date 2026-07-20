import QtQuick
import QtQuick.Layouts

// shadcn MessageFooter(base-mira)—— 气泡下方的状态/操作行。
// text-[0.625rem](10px)font-medium text-muted-foreground;随 align 靠边
// (由父 MessageContent 通过 Layout.alignment 决定)。可含状态文本 + 一组操作按钮。
// 默认子项追加在文本之后(如 MessageActions)。
// 注:官方 px-2.5 的水平内边距(使 footer 文本与气泡文本左缘对齐)基础版未精确复刻。
RowLayout {
    id: root

    property string text: ""
    property bool destructive: false

    // 状态文本之后的附加内容(如操作按钮组)。
    default property alias content: root.data

    spacing: Theme.space2                       // gap-2

    Text {
        visible: root.text !== ""
        text: root.text
        color: root.destructive ? Theme.destructive : Theme.mutedForeground
        font.pixelSize: 10                      // text-[0.625rem]
        font.weight: Font.Medium
    }
}
