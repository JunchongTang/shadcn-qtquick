import QtQuick
import QtQuick.Layouts

/*!
    \qmltype SidebarGroup
    \inqmlmodule Shadcn
    \inherits Item
    \brief A titled section within \l SidebarContent.

    SidebarGroup is the QML port of shadcn's \c SidebarGroup
    (\c .cn-sidebar-group). It applies \c px-2 (8px) horizontal padding and
    \c py-1 (4px) vertical padding, and stacks its children vertically. A group
    typically holds a \l SidebarGroupLabel followed by a \l SidebarMenu.

    \note The web component's \c SidebarGroupContent (a \c w-full wrapper) is not
    reproduced; place the menu directly inside the group.

    \sa SidebarContent, SidebarGroupLabel, SidebarMenu
*/
Item {
    id: control

    /*! \qmlproperty list<QtObject> SidebarGroup::content
        Default child list, stacked vertically inside the padded column. */
    default property alias content: inner.data

    Layout.fillWidth: true
    implicitHeight: inner.implicitHeight + 8    // py-1 (4px top + 4px bottom)

    ColumnLayout {
        id: inner
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 8                   // px-2
        anchors.rightMargin: 8
        anchors.topMargin: 4                    // py-1
        spacing: 0
    }
}
