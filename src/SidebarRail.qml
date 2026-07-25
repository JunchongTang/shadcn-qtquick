import QtQuick

/*!
    \qmltype SidebarRail
    \inqmlmodule Shadcn
    \inherits Item
    \brief A thin edge strip that toggles the \l Sidebar when clicked.

    SidebarRail is the QML port of shadcn's \c SidebarRail
    (\c .cn-sidebar-rail). It is a \c w-4 (16px) wide strip placed over the
    sidebar's edge. On hover a 2px \c sidebar-border line appears down the
    centre, fading in with a linear transition. Clicking it toggles the target
    sidebar's \l {Sidebar::collapsed}{collapsed} state.

    Position it over the sidebar edge yourself (via anchors) and bind \l sidebar
    to the target \l Sidebar.

    \note Simplified: no drag-to-resize; only click-to-toggle. RTL mirroring of
    the position is not handled.

    \sa Sidebar, SidebarTrigger
*/
Item {
    id: control

    /*!
        \qmlproperty var SidebarRail::sidebar
        The target \l Sidebar to toggle (must be bound by the caller).
    */
    property var sidebar: null

    implicitWidth: 16                // w-4

    // Centre line: appears on hover with a linear fade.
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 2
        color: hover.hovered ? Theme.sidebarBorder : Theme.alpha(Theme.sidebarBorder, 0)
        Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.Linear }
        }
    }

    HoverHandler {
        id: hover
        cursorShape: Qt.SplitHCursor     // in-data-[side=left]:cursor-w-resize
    }
    TapHandler {
        onTapped: if (control.sidebar) control.sidebar.collapsed = !control.sidebar.collapsed
    }
}
