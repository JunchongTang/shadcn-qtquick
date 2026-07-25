import QtQuick

/*!
    \qmltype SidebarTrigger
    \inqmlmodule Shadcn
    \inherits IconButton
    \brief A button that toggles a \l Sidebar between expanded and collapsed.

    SidebarTrigger is the QML port of shadcn's \c SidebarTrigger: a ghost
    \l IconButton at the \c icon-sm size (24px) showing the \c panel-left icon.
    Bind \l sidebar to the target \l Sidebar; clicking flips its
    \l {Sidebar::collapsed}{collapsed} state.

    \sa Sidebar, SidebarRail
*/
IconButton {
    id: control

    /*!
        \qmlproperty var SidebarTrigger::sidebar
        The target \l Sidebar to toggle (must be bound by the caller).
    */
    property var sidebar: null

    variant: IconButton.Ghost
    size: IconButton.Small           // 24 = icon-sm (size-6)
    iconName: "panel-left"

    onClicked: if (sidebar) sidebar.collapsed = !sidebar.collapsed
}
