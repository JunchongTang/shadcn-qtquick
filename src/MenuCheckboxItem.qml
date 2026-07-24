import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import LucideIcons

/*!
    \qmltype MenuCheckboxItem
    \inqmlmodule Shadcn
    \inherits MenuItem
    \brief A checkable \l Menu row with a trailing check indicator.

    MenuCheckboxItem is the QML port of shadcn/ui's
    \c DropdownMenuCheckboxItem (base-mira). The checked state is shown by a
    trailing CheckIcon (the item-indicator is positioned \c {right-2}; the row
    reserves the slot with \c pr-8). It is \c checkable, so toggling flips its
    \c checked state.

    The file name has no base-type clash, but the class is a
    \l[QtQuickControls]{MenuItem}; the base is imported under the \c C alias for
    consistency with the rest of the Menu family.

    \qmlproperty string MenuCheckboxItem::iconName
    Optional leading \l LucideIcon (e.g. the checkboxes-with-icons example).
    Empty hides the icon.

    \qmlproperty bool MenuCheckboxItem::inset
    When \c true the content is indented to align with items that have a leading
    icon (\c {data-inset}).
*/
C.MenuItem {
    id: control

    property string iconName: ""     // optional leading icon (e.g. checkboxes-icons example)
    property bool inset: false       // data-inset: pl-7.5 (30px)

    checkable: true
    implicitHeight: 28               // min-h-7
    leftPadding: inset ? 30 : Theme.space2   // pl-7.5 when inset, else pl-2
    rightPadding: Theme.space8       // pr-8 (32) reserves the indicator gutter
    topPadding: Theme.space1_5       // py-1.5
    bottomPadding: Theme.space1_5
    spacing: Theme.space2            // gap-2
    font.pixelSize: Theme.textXs
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5     // data-disabled:opacity-50
    arrow: null

    // Width is computed from content (the right indicator lives in rightPadding),
    // so Menu can grow to the widest item and never elide the label (#021).
    implicitWidth: leftPadding + rightPadding
                   + (iconName !== "" ? 14 + spacing : 0)
                   + Math.ceil(_labelMetrics.advanceWidth) + 1
    TextMetrics { id: _labelMetrics; font: control.font; text: control.text }

    // Disabled items never highlight (data-disabled:pointer-events-none).
    readonly property bool _active: control.enabled && (control.highlighted || control.hovered)
    readonly property color _fg: control._active ? Theme.accentForeground : Theme.popoverForeground

    // Trailing check indicator (cn-dropdown-menu-item-indicator: absolute right-2).
    indicator: LucideIcon {
        x: control.width - width - Theme.space2
        y: (control.height - height) / 2
        name: "check"
        size: 14                     // svg size-3.5
        color: control._fg
        visible: control.checked
    }

    contentItem: RowLayout {
        spacing: control.spacing
        LucideIcon {
            visible: control.iconName !== ""
            name: control.iconName
            size: 14
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
    }

    background: Rectangle {
        radius: Theme.radiusMd       // rounded-md
        color: control._active ? Theme.accent : "transparent"  // focus:bg-accent
    }
}
