import QtQuick
import QtQuick.Layouts

/*!
    \qmltype NavigationMenuLink
    \inqmlmodule Shadcn
    \inherits Item
    \brief A single link row inside a navigation dropdown panel.

    NavigationMenuLink matches base-mira's \c .cn-navigation-menu-link:
    \c flex \c items-center \c gap-1.5, \c p-2, \c text-xs/relaxed,
    \c hover:bg-muted, and \c data-[active=true]:bg-muted/50. Inside a
    NavigationMenuContent panel it uses \c rounded-md
    (\c in-data-[slot=navigation-menu-content]:rounded-md).

    Three layouts adapt automatically: title only; title + leading icon
    (\c size-4); or title + muted description (\c line-clamp-2, two lines).
    Clicking emits \l triggered; when clicked inside a panel the host
    NavigationMenuItem closes the menu.

    \sa NavigationMenuContent, NavigationMenuItem
*/
Item {
    id: link

    /*!
        \qmlproperty string NavigationMenuLink::text
        The link title.
    */
    property string text: ""
    /*!
        \qmlproperty string NavigationMenuLink::description
        Optional secondary description (muted, up to two lines).
    */
    property string description: ""
    /*!
        \qmlproperty string NavigationMenuLink::iconName
        Optional leading Lucide icon (kebab-case name).
    */
    property string iconName: ""
    /*!
        \qmlproperty bool NavigationMenuLink::active
        The \c data-[active=true] state (persistent muted background). Defaults to \c false.
    */
    property bool active: false

    /*!
        \qmlsignal NavigationMenuLink::triggered()
        Emitted when the link is clicked.
    */
    signal triggered()

    Layout.fillWidth: true
    implicitWidth: 180
    implicitHeight: col.implicitHeight + Theme.space2 * 2   // p-2

    /*! \internal Whether the pointer is over the link. */
    readonly property bool _hovered: hover.hovered

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusMd   // in-content: rounded-md
        color: {
            if (link.active)
                return link._hovered ? Theme.muted : Theme.alpha(Theme.muted, 0.5)
            return link._hovered ? Theme.muted : "transparent"
        }
    }

    ColumnLayout {
        id: col
        x: Theme.space2
        y: Theme.space2
        width: parent.width - Theme.space2 * 2
        spacing: link.description !== "" ? Theme.space1 : 0

        // Title row (icon + text).
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.space1_5   // gap-1.5

            Icon {
                visible: link.iconName !== ""
                name: link.iconName
                size: 16              // size-4
                color: Theme.foreground
                Layout.preferredWidth: visible ? 16 : 0
                Layout.preferredHeight: 16
            }
            Text {
                Layout.fillWidth: true
                text: link.text
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                font.weight: Font.Medium   // leading-none font-medium
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Description (optional, two-line clamp).
        Text {
            visible: link.description !== ""
            Layout.fillWidth: true
            text: link.description
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            lineHeight: Theme.lineRelaxed
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
            maximumLineCount: 2        // line-clamp-2
            elide: Text.ElideRight
        }
    }

    HoverHandler { id: hover }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: link.triggered()
    }
}
