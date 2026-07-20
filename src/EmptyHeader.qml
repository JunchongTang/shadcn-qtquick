import QtQuick
import QtQuick.Layouts

// shadcn EmptyHeader(base-mira) —— 包裹 media / title / description。
// 对齐 .cn-empty-header:flex-col items-center max-w-sm gap-1。
ColumnLayout {
    id: control

    // max-w-sm = 24rem = 384;固定内容宽度以便标题/描述居中换行,可被消费方覆盖。
    property int maxWidth: 384

    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: maxWidth
    spacing: Theme.space1    // gap-1 = 4
}
