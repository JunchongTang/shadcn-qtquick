import QtQuick.Layouts

// shadcn ItemActions —— 右侧动作位:按钮 / 图标等,gap-2、居中、不拉伸(靠内容拉伸挤到右侧)。
RowLayout {
    readonly property string itemSlot: "item-actions"

    spacing: Theme.space2   // gap-2
    Layout.alignment: Qt.AlignVCenter
}
