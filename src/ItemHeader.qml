import QtQuick.Layouts

// shadcn ItemHeader —— 位于内容上方、独占整行(basis-full),两端对齐、gap-2。
// 常用于放整行图片或「标题 + 操作」。由父 Item 迁至 header 区置顶。
RowLayout {
    readonly property string itemSlot: "item-header"

    Layout.fillWidth: true
    spacing: Theme.space2   // gap-2
}
