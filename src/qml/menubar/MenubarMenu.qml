import QtQuick

/*!
    \qmltype MenubarMenu
    \inqmlmodule Shadcn
    \inherits Item
    \brief A single trigger-plus-dropdown entry inside a \l Menubar.

    MenubarMenu pairs a \l MenubarTrigger button with a styled dropdown \l Menu.
    Declared children fall into the internal Menu, so the same items used with a
    standalone Menu apply here (MenuItem, MenuSeparator, MenuLabel,
    MenuCheckboxItem, MenuRadioItem and nested submenus).

    When placed in a \l Menubar the bar injects itself via \l bar, enabling
    hover-to-switch: while one menu is open, hovering another trigger opens that
    menu instead. The dropdown pops below the trigger with \c sideOffset 8 and
    \c alignOffset -4, matching base-mira's \c MenubarContent defaults.

    \qml
    MenubarMenu {
        title: "File"
        MenuItem { text: "New Tab" }
        MenuItem { text: "New Window" }
    }
    \endqml
*/
Item {
    id: mm

    /*!
        \qmlproperty string MenubarMenu::title
        Text shown on the trigger button (for example "File" or "Edit").
    */
    property string title: ""

    /*!
        \qmlproperty real MenubarMenu::menuWidth
        Preferred width of the dropdown content panel (defaults to min-w-32 = 128).
    */
    property alias menuWidth: popup.implicitWidth

    /*!
        \qmlproperty Item MenubarMenu::bar
        The owning \l Menubar, injected by it to enable hover-to-switch. \c null
        when the menu is used standalone.
    */
    property Item bar: null

    /*!
        \qmlproperty bool MenubarMenu::isMenubarMenu
        Read-only marker used by \l Menubar to identify its menu children.
    */
    readonly property bool isMenubarMenu: true

    /*!
        \qmlproperty bool MenubarMenu::opened
        Read-only; \c true while the dropdown is visible.
    */
    readonly property bool opened: popup.visible

    /*!
        \qmlproperty list<QtObject> MenubarMenu::content
        \qmldefault
        Default child list; declared items fall into the internal \l Menu.
    */
    default property alias content: popup.contentData

    implicitWidth: trigger.implicitWidth
    height: parent ? parent.height : trigger.implicitHeight

    MenubarTrigger {
        id: trigger
        anchors.fill: parent
        text: mm.title
        open: popup.visible
        onClicked: mm.toggle()
        // Menu-bar linkage: when a menu is already open, hovering another
        // trigger switches to it (standard desktop menu-bar behaviour).
        onHoveredChanged: {
            if (hovered && mm.bar && mm.bar.openMenu && mm.bar.openMenu !== mm)
                mm.openNow()
        }
    }

    // Dropdown content panel, reusing the styled Menu (rounded-lg + ring + shadow).
    Menu {
        id: popup
        onClosed: if (mm.bar && mm.bar.openMenu === mm) mm.bar.openMenu = null
    }

    /*!
        \qmlmethod MenubarMenu::openNow()
        Opens the dropdown, closing any other menu currently open in the bar and
        claiming \l {Menubar::openMenu}{openMenu}. Positioned with alignOffset -4
        and sideOffset 8.
    */
    function openNow() {
        if (mm.bar) {
            if (mm.bar.openMenu && mm.bar.openMenu !== mm)
                mm.bar.openMenu.close()
            mm.bar.openMenu = mm
        }
        popup.popup(trigger, -4, trigger.height + 8)
    }

    /*!
        \qmlmethod MenubarMenu::close()
        Closes the dropdown.
    */
    function close() { popup.close() }

    /*!
        \qmlmethod MenubarMenu::toggle()
        Opens the dropdown if closed, or closes it if open.
    */
    function toggle() { popup.visible ? popup.close() : openNow() }
}
