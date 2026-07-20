import QtQuick
import QtQuick.Layouts

// shadcn FieldLabel —— 字段标签(基于 Shadcn Label:text-xs / medium / 禁用变暗)。
// leading-snug、可换行;默认占满宽度(横排时 flex-auto 把控件推到右侧)。
// 选择卡(把 Field 包进 FieldLabel)的边框/圆角/选中背景由 demo 侧的卡片容器还原。
Label {
    property bool invalid: false        // 随 Field.invalid 转破坏色

    Layout.fillWidth: true
    color: invalid ? Theme.destructive : Theme.foreground
    wrapMode: Text.Wrap
    horizontalAlignment: Text.AlignLeft
    lineHeight: 1.375                    // leading-snug
    lineHeightMode: Text.ProportionalHeight
}
