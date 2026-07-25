import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import LucideIcons

/*!
    \qmltype MenuItem
    \inqmlmodule Shadcn
    \inherits QtQuick.Controls.MenuItem
    \brief A selectable row in a \l Menu.

    MenuItem is the QML port of shadcn/ui's \c DropdownMenuItem (base-mira). It
    is a \l[QtQuickControls]{MenuItem} styled with an optional leading icon, a
    label, and an optional trailing keyboard shortcut. When used as a submenu
    trigger (its \c subMenu is set) it draws a trailing chevron and takes its
    leading icon from the submenu's \c icon.name.

    The file name shadows the Controls base type, so the base is imported under
    the \c C alias and used as the root (\c C.MenuItem). The inherited \c text
    (from AbstractButton) is reused directly rather than redeclared.
*/
C.MenuItem {
    id: control

    /*!
        \qmlproperty string MenuItem::shortcut
        Trailing keyboard-shortcut hint, rendered small and muted. Empty hides it.
    */
    property string shortcut: ""     // trailing keyboard-shortcut hint (muted)
    /*!
        \qmlproperty string MenuItem::iconName
        Name of the leading \l LucideIcon. Empty hides the icon. A separate property
        is used because AbstractButton's \c icon grouped property is \c FINAL.
    */
    property string iconName: ""     // leading Lucide icon (icon is FINAL, hence iconName)
    /*!
        \qmlproperty bool MenuItem::destructive
        When \c true the item uses the destructive foreground colour and a
        destructive-tinted highlight (\c {data-variant=destructive}).
    */
    property bool destructive: false // data-[variant=destructive]: destructive text + tinted focus bg
    /*!
        \qmlproperty bool MenuItem::inset
        When \c true the content is indented to align with items that have a leading
        icon or indicator (\c {data-inset:pl-7.5}).
    */
    property bool inset: false       // data-inset: pl-7.5 (30px)

    implicitHeight: 28               // min-h-7
    leftPadding: inset ? 30 : Theme.space2   // pl-7.5 when inset, else px-2
    rightPadding: Theme.space2
    topPadding: 0
    bottomPadding: 0
    spacing: Theme.space2            // gap-2
    font.pixelSize: Theme.textXs
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5     // data-disabled:opacity-50
    indicator: null
    arrow: null

    // Width is computed from content: a RowLayout with a fillWidth Text does not
    // report a usable implicitWidth, which would clamp the Menu to its min-width
    // and elide the label. This lets Menu grow to the widest item (#021).
    implicitWidth: leftPadding + rightPadding
                   + (_iconName !== "" ? 14 + spacing : 0)
                   + Math.ceil(_labelMetrics.advanceWidth) + 1
                   + (shortcut !== "" ? spacing + Math.ceil(_shortcutMetrics.advanceWidth) : 0)
                   + (subMenu !== null ? spacing + 14 : 0)
    TextMetrics { id: _labelMetrics; font: control.font; text: control.text }
    TextMetrics { id: _shortcutMetrics; font.pixelSize: 10; font.letterSpacing: 1; text: control.shortcut }

    // Disabled items never highlight (data-disabled:pointer-events-none).
    readonly property bool _active: control.enabled && (control.highlighted || control.hovered)
    // Submenu trigger items are created by Menu's delegate (subMenu is set);
    // their leading icon comes from the submenu's icon.name.
    readonly property string _iconName: control.subMenu ? control.subMenu.icon.name : control.iconName
    readonly property color _fg: control.destructive
        ? Theme.destructive
        : (control._active ? Theme.accentForeground : Theme.popoverForeground)

    contentItem: RowLayout {
        spacing: control.spacing
        LucideIcon {
            visible: control._iconName !== ""
            name: control._iconName
            size: 14                 // svg size-3.5
            color: control._fg
            Layout.preferredWidth: visible ? 14 : 0
            Layout.preferredHeight: 14
        }
        Text {
            text: control.text
            font: control.font
            color: control._fg
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            Layout.fillWidth: true
        }
        Text {
            visible: control.shortcut !== ""
            text: control.shortcut
            font.pixelSize: 10       // text-[0.625rem]
            font.letterSpacing: 1    // tracking-widest
            color: control._active ? Theme.accentForeground : Theme.mutedForeground
            verticalAlignment: Text.AlignVCenter
        }
        // Submenu trigger chevron (sub-trigger: ChevronRightIcon ml-auto).
        LucideIcon {
            visible: control.subMenu !== null
            name: "chevron-right"
            size: 14
            color: control._fg
            Layout.preferredWidth: visible ? 14 : 0
            Layout.preferredHeight: 14
        }
    }

    background: Rectangle {
        radius: Theme.radiusMd       // rounded-md
        // focus:bg-accent / destructive focus:bg-destructive/10 (dark:/20)
        color: control.destructive
            ? (control._active ? Theme.alpha(Theme.destructive, Theme.dark ? 0.2 : 0.1) : "transparent")
            : (control._active ? Theme.accent : "transparent")
    }
}
