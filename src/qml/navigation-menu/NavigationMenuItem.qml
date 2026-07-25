import QtQuick

/*!
    \qmltype NavigationMenuItem
    \inqmlmodule Shadcn
    \inherits Item
    \brief A single entry in a NavigationMenu, either a dropdown or a plain link.

    NavigationMenuItem has two shapes, matching base-mira's usage:
    \list
    \li Dropdown: set \l text as the trigger header (with a chevron) and declare
        NavigationMenuLink children as the dropdown contents.
    \li Plain link: set \l asLink to \c true so the whole item is a clickable
        link (like the upstream "Docs" entry); clicking emits \l triggered.
    \endlist

    Hover coordination: entering the trigger asks the parent NavigationMenu to
    open this item; moving between items switches immediately. After the pointer
    leaves both the trigger and the panel, a 150ms grace timer closes the item.

    \note The grace timer bridges the 8px gap between the trigger and the panel.
    Upstream fills that gap with a CSS \c ::before pseudo-element; this is a
    deliberate simplification.

    \sa NavigationMenu, NavigationMenuTrigger, NavigationMenuContent, NavigationMenuLink
*/
Item {
    id: item

    /*!
        \qmlproperty string NavigationMenuItem::text
        The trigger header label.
    */
    property string text: ""
    /*!
        \qmlproperty bool NavigationMenuItem::asLink
        When \c true the whole item is a plain clickable link with no dropdown. Defaults to \c false.
    */
    property bool asLink: false
    /*!
        \qmlproperty int NavigationMenuItem::columns
        Dropdown grid column count (the components example uses 2). Defaults to \c 1.
    */
    property int columns: 1
    /*!
        \qmlproperty real NavigationMenuItem::contentWidth
        Dropdown panel width (w-96 default). Defaults to \c 384.
    */
    property real contentWidth: 384

    /*!
        \qmlsignal NavigationMenuItem::triggered()
        Emitted when a plain-link item, or one of its child links, is activated.
    */
    signal triggered()

    /*!
        \qmlproperty list<QtObject> NavigationMenuItem::content
        Default content slot; declared NavigationMenuLink children are
        routed into the dropdown panel's internal grid. This is the component's
        default property.
    */
    default property alias content: panel.links

    /*! \internal Whether this item owns a dropdown panel (i.e. is not a plain link). */
    readonly property bool _hasContent: !asLink
    /*! \internal The owning NavigationMenu (this item's RowLayout parent). */
    readonly property var _menu: item.parent

    implicitWidth: trigger.implicitWidth
    implicitHeight: trigger.implicitHeight

    NavigationMenuTrigger {
        id: trigger
        text: item.text
        showChevron: item._hasContent
        open: item._menu && item._menu.openItem === item

        onEntered: {
            closeTimer.stop()
            if (item._hasContent && item._menu)
                item._menu.requestOpen(item)
        }
        onExited: closeTimer.restart()
        onClicked: {
            if (item.asLink) {
                item.triggered()
            } else if (item._menu) {
                if (item._menu.openItem === item)
                    item._menu.requestClose(item)
                else
                    item._menu.requestOpen(item)
            }
        }
    }

    NavigationMenuContent {
        id: panel
        parent: trigger
        columns: item.columns
        width: item.contentWidth

        // Cancel the close timer while the panel is hovered; restart on leave.
        onHoveredChanged: hovered ? closeTimer.stop() : closeTimer.restart()

        // When the panel closes itself (Esc / press-outside), reset the container.
        onClosed: if (item._menu && item._menu.openItem === item) item._menu.requestClose(item)
    }

    // Close grace timer (bridges the trigger <-> panel gap).
    Timer {
        id: closeTimer
        interval: 150
        onTriggered: if (item._menu) item._menu.requestClose(item)
    }

    // Drive the panel open/close from the container's current open item.
    Connections {
        target: item._menu
        function onOpenItemChanged() {
            if (!item._hasContent)
                return
            if (item._menu.openItem === item)
                panel.open()
            else
                panel.close()
        }
    }

    // Close the whole menu after a child link is clicked. Links are declared
    // statically, so wiring happens once on completion.
    Component.onCompleted: {
        for (let i = 0; i < panel.links.length; ++i) {
            let obj = panel.links[i]
            if (obj && obj.triggered !== undefined)
                obj.triggered.connect(function() { if (item._menu) item._menu.closeAll() })
        }
    }
}
