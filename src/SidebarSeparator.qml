import QtQuick
import QtQuick.Layouts

// shadcn SidebarSeparator —— 1px 分隔线,bg-sidebar-border,左右 mx-2 内缩。
Item {
    Layout.fillWidth: true
    implicitHeight: 1

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 8        // mx-2
        anchors.rightMargin: 8
        height: 1
        color: Theme.sidebarBorder
    }
}
