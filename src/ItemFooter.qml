import QtQuick.Layouts

// shadcn ItemFooter —— 位于内容下方、独占整行(basis-full),两端对齐、gap-2。
// 由父 Item 迁至 footer 区置底。
RowLayout {
    readonly property string itemSlot: "item-footer"

    Layout.fillWidth: true
    spacing: Theme.space2   // gap-2
}
