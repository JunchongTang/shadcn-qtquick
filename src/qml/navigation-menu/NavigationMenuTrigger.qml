import QtQuick
import QtQuick.Layouts

/*!
    \qmltype NavigationMenuTrigger
    \inqmlmodule Shadcn
    \inherits Item
    \brief Clickable header of a navigation item, with an optional chevron.

    NavigationMenuTrigger renders the top-bar header of a NavigationMenuItem,
    styled after base-mira's \c .cn-navigation-menu-trigger: \c h-9,
    \c rounded-lg, \c px-2.5 \c py-1.5, \c text-xs/relaxed, \c font-medium. Hover
    paints a muted background; while the panel is open the background is
    \c bg-muted/50 (\c data-popup-open:bg-muted/50), and hovering an open trigger
    upgrades it to a solid \c bg-muted. The trailing \c chevron-down rotates 180
    degrees when open (\c group-data-open:rotate-180).

    It is instantiated inside NavigationMenuItem; it can also be reused
    standalone as a trigger-styled link. The \l entered, \l exited and \l clicked
    signals are forwarded to the host item so it can coordinate hover open/close.

    \sa NavigationMenuItem, NavigationMenu
*/
Item {
    id: trigger

    /*!
        \qmlproperty string NavigationMenuTrigger::text
        The header label.
    */
    property string text: ""
    /*!
        \qmlproperty bool NavigationMenuTrigger::showChevron
        Whether the trailing chevron is shown; pass \c false for a plain link item. Defaults to \c true.
    */
    property bool showChevron: true
    /*!
        \qmlproperty bool NavigationMenuTrigger::open
        Whether the associated panel is expanded (drives chevron rotation and background). Defaults to \c false.
    */
    property bool open: false

    /*!
        \qmlsignal NavigationMenuTrigger::entered()
        Emitted when the pointer enters the trigger.
    */
    signal entered()
    /*!
        \qmlsignal NavigationMenuTrigger::exited()
        Emitted when the pointer leaves the trigger.
    */
    signal exited()
    /*!
        \qmlsignal NavigationMenuTrigger::clicked()
        Emitted when the trigger is clicked.
    */
    signal clicked()

    // px-2.5 horizontal / py-1.5 vertical padding.
    readonly property real _hpad: Theme.space2_5
    readonly property real _vpad: Theme.space1_5
    // Minimum trigger height (Tailwind h-9 in the trigger cva).
    readonly property real _minHeight: 36

    implicitWidth: row.implicitWidth + _hpad * 2
    // h-9: enforce the 36px header height mandated by the trigger cva, while
    // still growing if the label ever needs more room.
    implicitHeight: Math.max(row.implicitHeight + _vpad * 2, _minHeight)

    // data-popup-open:bg-muted/50 . (open|hover):bg-muted . otherwise transparent.
    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusLg
        color: {
            if (trigger.open)
                return hover.hovered ? Theme.muted : Theme.alpha(Theme.muted, 0.5)
            return hover.hovered ? Theme.muted : Theme.alpha(Theme.muted, 0)
        }
        Behavior on color { ColorAnimation { duration: Theme.durBase } }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: Theme.space1   // ml-1

        Text {
            text: trigger.text
            color: Theme.foreground
            font.pixelSize: Theme.textXs
            font.weight: Font.Medium
            verticalAlignment: Text.AlignVCenter
        }
        Icon {
            visible: trigger.showChevron
            name: "chevron-down"
            size: 12                      // size-3
            color: Theme.foreground
            Layout.preferredWidth: visible ? 12 : 0
            // group-data-open:rotate-180, transition duration-300.
            rotation: trigger.open ? 180 : 0
            Behavior on rotation { NumberAnimation { duration: 300 } }
        }
    }

    HoverHandler { id: hover }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: trigger.entered()
        onExited: trigger.exited()
        onClicked: trigger.clicked()
    }
}
