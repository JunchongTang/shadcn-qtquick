import QtQuick
import QtQuick.Layouts

/*!
    \qmltype SidebarMenuItem
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief A single entry wrapper within a \l SidebarMenu.

    SidebarMenuItem is the QML port of shadcn's \c SidebarMenuItem (the
    relatively positioned \c <li>). It typically wraps one
    \l SidebarMenuButton.

    \note Simplified: the web component's menu-action, menu-badge and menu-sub
    slots are not implemented.

    \sa SidebarMenu, SidebarMenuButton
*/
ColumnLayout {
    Layout.fillWidth: true
    spacing: 1
}
