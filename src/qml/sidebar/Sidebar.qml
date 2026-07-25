import QtQuick
import QtQuick.Layouts

/*!
    \qmltype Sidebar
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief The root container of an application sidebar.

    Sidebar is the QML port of shadcn's \c Sidebar (base-mira). It paints the
    sidebar surface (\c bg-sidebar) with a 1px right border and stacks its
    children vertically as Header / Content / Footer.

    When \l collapsed is \c false the sidebar is \l expandedWidth wide
    (\c --sidebar-width, 16rem = 256px). When \l collapsed is \c true it shrinks
    to an icon rail of \l iconWidth (\c --sidebar-width-icon, 3rem = 48px):
    menu buttons collapse to centred icons and group labels fade out. The width
    change animates over 200ms with a linear easing, matching the
    \c .cn-sidebar-gap transition.

    Descendants read the collapsed state by walking up the parent chain until
    they find the item carrying \l _isSidebarRoot; this is a lightweight
    substitute for shadcn's \c SidebarProvider context.

    \note Simplified relative to the web component: the mobile sheet, the
    offcanvas / floating / inset variants, the \c side option, and cookie-based
    state persistence are not implemented.

    \qml
    Sidebar {
        collapsed: false
        SidebarHeader { }
        SidebarContent { }
        SidebarFooter { }
    }
    \endqml

    \sa SidebarContent, SidebarTrigger, SidebarRail
*/
Rectangle {
    id: root

    /*! \qmlproperty list<QtObject> Sidebar::content
        Default child list; children stack vertically (Header / Content / Footer). */
    default property alias content: col.data

    /*! \qmlproperty bool Sidebar::collapsed
        Whether the sidebar is collapsed to the icon rail. Defaults to \c false (expanded). */
    property bool collapsed: false
    /*! \qmlproperty int Sidebar::expandedWidth
        Width when expanded (\c --sidebar-width, 16rem). Defaults to 256. */
    property int expandedWidth: 256
    /*! \qmlproperty int Sidebar::iconWidth
        Width when collapsed to the icon rail (\c --sidebar-width-icon, 3rem). Defaults to 48. */
    property int iconWidth: 48
    /*! \qmlproperty bool Sidebar::_isSidebarRoot
        Marker read by descendants (via the parent chain) to locate the sidebar root. Always \c true. */
    readonly property bool _isSidebarRoot: true

    implicitWidth: collapsed ? iconWidth : expandedWidth
    color: Theme.sidebar
    clip: true

    // .cn-sidebar-gap: transition-[width] duration-200 ease-linear
    Behavior on implicitWidth {
        NumberAnimation { duration: 200; easing.type: Easing.Linear }
    }

    // Vertical stack for the Header / Content / Footer children.
    ColumnLayout {
        id: col
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 1       // keep clear of the right border
        spacing: 0
    }

    // border-r sidebar-border
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: Theme.sidebarBorder
    }
}
