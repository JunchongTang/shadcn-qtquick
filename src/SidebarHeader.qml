import QtQuick
import QtQuick.Layouts

// shadcn SidebarHeader —— 顶部区域,p-2 内边距 + gap-2 纵向间距。
Item {
    id: control
    default property alias content: inner.data

    Layout.fillWidth: true
    implicitHeight: inner.implicitHeight + 16   // p-2(上下各 8)

    ColumnLayout {
        id: inner
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 8                       // p-2
        spacing: 8                               // gap-2
    }
}
