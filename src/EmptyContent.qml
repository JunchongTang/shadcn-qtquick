import QtQuick
import QtQuick.Layouts

// shadcn EmptyContent(base-mira) —— 空状态动作/内容区(按钮、输入组、链接等)。
// 对齐 .cn-empty-content:flex-col items-center max-w-sm w-full gap-2 text-xs/relaxed。
// 子件需自行设 Layout.alignment: Qt.AlignHCenter(或用居中的 RowLayout)以水平居中。
ColumnLayout {
    id: control

    property int maxWidth: 384    // max-w-sm,可被消费方覆盖

    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: maxWidth
    spacing: Theme.space2         // gap-2 = 8
}
