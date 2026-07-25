import QtQuick
import QtQuick.Layouts
import LucideIcons

/*!
    \qmltype SidebarMenuButton
    \inqmlmodule Shadcn
    \inherits Item
    \brief A clickable icon + label entry inside a \l SidebarMenuItem.

    SidebarMenuButton is the QML port of shadcn's \c SidebarMenuButton
    (\c .cn-sidebar-menu-button). It is \c h-8 (32px) tall with
    \c rounded-[calc(var(--radius-sm)+2px)] (8px) corners, \c p-2 padding,
    \c gap-2 spacing and \c text-xs text. Hover or \l active paints
    \c bg-sidebar-accent with \c text-sidebar-accent-foreground; the active
    state also uses a \c Medium font weight.

    When the enclosing \l Sidebar is \l {Sidebar::collapsed}{collapsed} (the web
    component's \c collapsible=icon state) the button becomes a 32x32 square
    showing only the centred icon; the label is hidden and its original text is
    surfaced through a right-side \l Tooltip on hover. The collapsed state is
    resolved by walking up the parent chain to the sidebar root.

    \note Simplified: the size (sm / lg) and variant (outline) options and the
    menu-action right padding are not implemented.

    \qml
    SidebarMenuItem {
        SidebarMenuButton { iconName: "house"; text: "Home"; active: true }
    }
    \endqml

    \sa SidebarMenuItem, Sidebar
*/
Item {
    id: control

    /*!
        \qmlproperty string SidebarMenuButton::text
        The label text (hidden when collapsed).
    */
    property string text: ""
    /*!
        \qmlproperty string SidebarMenuButton::iconName
        Leading Lucide icon (kebab-case name).
    */
    property string iconName: ""
    /*!
        \qmlproperty bool SidebarMenuButton::active
        Whether this entry is the active one; paints the accent background.
    */
    property bool active: false
    /*!
        \qmlsignal SidebarMenuButton::clicked()
        Emitted when the entry is tapped.
    */
    signal clicked()

    /*! \qmlproperty bool SidebarMenuButton::collapsed
        Mirrors the enclosing \l Sidebar's collapsed state (resolved via the parent chain). */
    property bool collapsed: {
        var p = parent
        while (p) {
            if (p._isSidebarRoot === true)
                return p.collapsed
            p = p.parent
        }
        return false
    }

    Layout.fillWidth: true
    implicitHeight: 32                                   // h-8
    implicitWidth: collapsed ? 32 : row.implicitWidth + 16  // group-data-[collapsible=icon]:size-8!

    Behavior on implicitWidth {
        NumberAnimation { duration: 200; easing.type: Easing.Linear }
    }

    /*!
        \qmlproperty bool SidebarMenuButton::_hovered
        \c true while the pointer hovers the entry.
    */
    readonly property bool _hovered: hover.hovered
    /*!
        \qmlproperty color SidebarMenuButton::_fg
        Foreground color: accent when active/hovered, otherwise sidebar foreground.
    */
    readonly property color _fg: (control.active || control._hovered)
        ? Theme.sidebarAccentForeground
        : Theme.sidebarForeground

    // Accent background painted on hover / active.
    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusMd                           // calc(radius-sm + 2px) = 8
        color: (control.active || control._hovered) ? Theme.sidebarAccent : "transparent"
    }

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.leftMargin: 8                            // p-2
        anchors.rightMargin: 8
        spacing: control.collapsed ? 0 : 8               // gap-2

        LucideIcon {
            visible: control.iconName !== ""
            name: control.iconName
            size: 16                                     // [&_svg]:size-4
            color: control._fg
            Layout.preferredWidth: visible ? 16 : 0
            Layout.preferredHeight: 16
        }
        Text {
            id: label
            // Hidden when collapsed, leaving only the centred icon.
            visible: !control.collapsed && control.text !== ""
            Layout.fillWidth: !control.collapsed
            Layout.preferredWidth: control.collapsed ? 0 : label.implicitWidth
            text: control.text
            color: control._fg
            font.pixelSize: Theme.textXs
            font.weight: control.active ? Font.Medium : Font.Normal
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    HoverHandler { id: hover }
    TapHandler { onTapped: control.clicked() }

    // Collapsed state: reveal the label via a right-side tooltip on hover.
    Tooltip {
        text: control.text
        side: Tooltip.Side.RightEdge
        visible: control.collapsed && control._hovered && control.text !== ""
    }
}
