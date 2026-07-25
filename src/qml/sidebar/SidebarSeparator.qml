import QtQuick
import QtQuick.Layouts

/*!
    \qmltype SidebarSeparator
    \inqmlmodule Shadcn
    \inherits Item
    \brief A 1px horizontal divider within a \l Sidebar.

    SidebarSeparator is the QML port of shadcn's \c SidebarSeparator
    (\c .cn-sidebar-separator). It draws a 1px line in \c sidebar-border, inset
    by \c mx-2 (8px) on each side.

    \sa Sidebar, SidebarGroup
*/
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
