import QtQuick
import QtQuick.Layouts

/*!
    \qmltype NavigationMenu
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief Horizontal navigation bar that hosts NavigationMenuItem entries.
    \image navigation-menu.png


    NavigationMenu is the root container of the navigation-menu family, styled
    after shadcn's base-mira \c .cn-navigation-menu / \c .cn-navigation-menu-list
    rules: a \c max-w-max, \c items-center row with \c gap-0 (items sit flush).
    Declare NavigationMenuItem children directly inside it.

    It implements a single-open model: at most one item's dropdown panel is
    expanded at a time. Each item locates this container through its \c parent
    and calls \l requestOpen / \l requestClose to coordinate; moving the pointer
    between items switches the open panel immediately (see NavigationMenuItem).

    \note The upstream \c viewport size/position tween (a single panel that
    morphs between items) is simplified here: every item owns an independent
    popover panel, and switching fades the old panel out while the new one
    fades in, with no cross-item morph animation.

    \qml
    NavigationMenu {
        NavigationMenuItem {
            text: "Getting started"
            NavigationMenuLink { text: "Introduction"; description: "..." }
        }
        NavigationMenuItem { text: "Docs"; asLink: true }
    }
    \endqml

    \sa NavigationMenuItem, NavigationMenuTrigger, NavigationMenuContent, NavigationMenuLink
*/
RowLayout {
    id: root

    /*!
        \qmlproperty var NavigationMenu::openItem
        The currently expanded NavigationMenuItem, or \c null when every item is
        collapsed. Items bind their open state to this value.
    */
    property var openItem: null

    spacing: 0   // gap-0

    /*!
        \qmlmethod void NavigationMenu::requestOpen(var item)
        Requests that \a item become the single open item, collapsing any other.
    */
    function requestOpen(item) { root.openItem = item }

    /*!
        \qmlmethod void NavigationMenu::requestClose(var item)
        Collapses \a item if it is currently the open item; otherwise a no-op.
    */
    function requestClose(item) { if (root.openItem === item) root.openItem = null }

    /*!
        \qmlmethod void NavigationMenu::closeAll()
        Collapses whichever item is open.
    */
    function closeAll() { root.openItem = null }
}
