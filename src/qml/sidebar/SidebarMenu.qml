import QtQuick
import QtQuick.Layouts

/*!
    \qmltype SidebarMenu
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief A vertical list of menu entries within a \l SidebarGroup.

    SidebarMenu is the QML port of shadcn's \c SidebarMenu
    (\c .cn-sidebar-menu). It stacks \l SidebarMenuItem children vertically with
    a 1px gap (\c gap-px).

    \sa SidebarMenuItem, SidebarMenuButton
*/
ColumnLayout {
    Layout.fillWidth: true
    spacing: 1                       // .cn-sidebar-menu gap-px
}
