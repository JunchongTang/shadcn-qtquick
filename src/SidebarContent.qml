import QtQuick
import QtQuick.Layouts

// shadcn SidebarContent —— 占据剩余高度、可滚动的分组区(overflow-auto,gap-0)。
// 用库内 ScrollView(细滚动条),子分组进内部 ColumnLayout。
ScrollView {
    id: sc
    default property alias content: inner.data

    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true

    ColumnLayout {
        id: inner
        width: sc.availableWidth
        spacing: 0                    // .cn-sidebar-content gap-0
    }
}
