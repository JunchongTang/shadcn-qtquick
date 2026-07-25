import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import QtQuick.Effects

/*!
    \qmltype NavigationMenuContent
    \inqmlmodule Shadcn
    \inherits Popup
    \brief Dropdown panel expanded from a navigation item.

    NavigationMenuContent is the popover surface shown below an open
    NavigationMenuItem. It matches base-mira's \c .cn-navigation-menu-popup
    (\c rounded-xl, \c ring-1 \c ring-foreground/10, shadow) and
    \c .cn-navigation-menu-content (\c p-1.5). Qt Quick Controls has no dedicated
    Popover type, so this is built on \c C.Popup (same approach as Popover.qml).
    Declared NavigationMenuLink children are laid out in an internal GridLayout:
    \l columns = 1 stacks them vertically, \c > 1 forms a grid.

    It is instantiated inside NavigationMenuItem; NavigationMenuLink children
    reach the internal grid through the default property alias.

    \sa NavigationMenuItem, NavigationMenuLink
*/
C.Popup {
    id: content

    /*! \qmlproperty int NavigationMenuContent::columns \brief Number of grid columns for the links (1 = vertical stack). Defaults to \c 1. */
    property int columns: 1
    /*! \qmlproperty int NavigationMenuContent::sideOffset \brief Vertical gap between the trigger and the panel (side=bottom). Defaults to \c 8. */
    property int sideOffset: 8

    /*!
        \qmlproperty list<QtObject> NavigationMenuContent::links
        \brief Default content slot; declared NavigationMenuLink children go
        straight into the internal grid. This is the component's default
        property.
    */
    default property alias links: grid.data

    /*!
        \qmlproperty bool NavigationMenuContent::hovered
        \brief Whether the pointer is over the panel; the host item reads this to
        keep the panel open while it is hovered. Read-only.
    */
    property alias hovered: panelHover.hovered

    width: 384                   // default w-96; overridden by the item
    padding: Theme.space1_5      // p-1.5
    font.pixelSize: Theme.textXs
    modal: false
    dim: false
    closePolicy: C.Popup.CloseOnEscape | C.Popup.CloseOnPressOutside

    // Position: directly below the trigger (parent), align=start.
    y: (parent ? parent.height : 0) + sideOffset
    x: 0

    background: Rectangle {
        color: Theme.popover
        radius: Theme.radiusXl   // rounded-xl
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: Theme.shadowColor
            shadowBlur: Theme.shadowBlur
            shadowVerticalOffset: Theme.shadowOffset
        }
    }

    contentItem: GridLayout {
        id: grid
        columns: content.columns
        rowSpacing: Theme.space2      // gap-2
        columnSpacing: Theme.space2

        // Whole-panel hover probe (does not intercept link clicks).
        HoverHandler { id: panelHover }
    }

    // Open: fade + zoom (data-starting-style: scale-90 opacity-0). Close is symmetric.
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durBase }
        NumberAnimation { property: "scale"; from: 0.9; to: 1; duration: Theme.durBase }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durFast }
        NumberAnimation { property: "scale"; from: 1; to: 0.9; duration: Theme.durFast }
    }
}
