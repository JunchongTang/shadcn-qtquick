import QtQuick
import QtQuick.Layouts

// shadcn SidebarFooter —— 底部区域,p-2 内边距 + gap-2 纵向间距。
Item {
    id: control
    default property alias content: inner.data

    Layout.fillWidth: true
    implicitHeight: inner.implicitHeight + 16   // p-2

    ColumnLayout {
        id: inner
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 8
        spacing: 8
    }
}
