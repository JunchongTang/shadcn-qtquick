import QtQuick
import QtQuick.Layouts

/*!
    \qmltype SidebarContent
    \inqmlmodule Shadcn
    \inherits ScrollView
    \brief The scrollable body region of a \l Sidebar.

    SidebarContent is the QML port of shadcn's \c SidebarContent
    (\c .cn-sidebar-content). It fills the remaining height of the sidebar and
    scrolls when its groups overflow. Children (typically \l SidebarGroup) stack
    vertically with no gap (\c gap-0).

    \sa Sidebar, SidebarGroup, SidebarMenu
*/
ScrollView {
    id: sc

    /*! \qmlproperty list<QtObject> SidebarContent::content
        \brief Default child list placed in the scrolling column (typically \l SidebarGroup items). */
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
