import QtQuick
import QtQuick.Layouts

// shadcn CardContent —— 正文区容器。水平内边距由 Card 统一提供。
// edgeToEdge:内容铺满到卡片左右边缘(对标官方 -mx-(--card-spacing)),
// 用负边距抵消 Card 施加的水平统一内边距;内部子项可再自行加回 px 对齐卡片 inset。
ColumnLayout {
    id: content

    property bool edgeToEdge: false

    // Card 的统一内边距 = 其内容列(此 item 的 parent)anchors.margins(= cardSpacing)。
    readonly property real _inset: (parent && parent.anchors) ? parent.anchors.margins : 0

    Layout.fillWidth: true
    Layout.leftMargin: edgeToEdge ? -_inset : 0
    Layout.rightMargin: edgeToEdge ? -_inset : 0
    spacing: Theme.space2
}
