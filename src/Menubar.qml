import QtQuick

/*!
    \qmltype Menubar
    \inqmlmodule Shadcn
    \inherits Item
    \brief A desktop-style application menu bar, styled after shadcn's base-mira menubar.

    Menubar renders shadcn's \c .cn-menubar: a horizontal row of \l MenubarMenu
    triggers inside a \c rounded-lg bordered container with \c p-1 padding and
    \c h-9 (36px) height. The container has no fill; only the rounded border and
    padding are drawn.

    Declared \l MenubarMenu children are laid out left-to-right. The bar tracks a
    single \l openMenu at a time and injects itself into each child so that once
    one menu is open, hovering another trigger switches to it (the usual desktop
    menu-bar behaviour).

    \qml
    Menubar {
        MenubarMenu {
            title: "File"
            MenuItem { text: "New Tab" }
            MenuItem { text: "New Window" }
        }
        MenubarMenu {
            title: "Edit"
            MenuItem { text: "Undo" }
        }
    }
    \endqml
*/
Item {
    id: control

    /*!
        \qmlproperty Item Menubar::openMenu
        The currently expanded \l MenubarMenu, or \c null when all menus are
        collapsed. Used to drive hover-to-switch between menus.
    */
    property Item openMenu: null

    /*!
        \qmlproperty list<QtObject> Menubar::content
        \qmldefault
        Default child list; declared \l MenubarMenu items fall into the internal Row.
    */
    default property alias content: row.data

    implicitWidth: row.implicitWidth + Theme.space1 * 2   // p-1 on both sides
    implicitHeight: 36                                     // h-9

    // rounded-lg border with a transparent fill.
    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusLg
        color: "transparent"
        border.width: 1
        border.color: Theme.border
    }

    Row {
        id: row
        x: Theme.space1                 // p-1
        y: Theme.space1
        height: parent.height - Theme.space1 * 2
        spacing: Theme.space0_5         // small gap between triggers
    }

    // Inject self into every MenubarMenu.bar to wire up hover-to-switch.
    Component.onCompleted: {
        for (var i = 0; i < row.children.length; ++i) {
            var c = row.children[i]
            if (c && c.isMenubarMenu === true)
                c.bar = control
        }
    }
}
