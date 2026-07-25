import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import LucideIcons

/*!
    \qmltype Toggle
    \inqmlmodule Shadcn
    \inherits Button
    \brief A two-state (on/off) button.

    Toggle is a checkable button styled after shadcn's base-mira \c .cn-toggle-*
    rules. It reuses the checked state of the Qt Quick Controls \c Button: the
    pressed/on state (\c data-[state=on]) and hover both paint a muted background,
    while the label and optional icon always use the foreground color.

    Use \l variant for the visual style and \l size for the compact size scale.

    \qml
    Toggle { iconName: "bold"; text: "Bold" }
    Toggle { variant: Toggle.Outline; size: Toggle.Sm; text: "Italic" }
    \endqml

    \sa ToggleGroup
*/
C.Button {
    id: control

    /*!
        \qmlproperty enumeration Toggle::variant
        Visual style:
        \value Toggle.Default Transparent background (muted on hover/on).
        \value Toggle.Outline Adds a 1px input-colored border.
    */
    enum Variant { Default, Outline }

    /*!
        \qmlproperty enumeration Toggle::size
        Compact size scale (height 24 / 28 / 32):
        \value Toggle.Default 28px, 12px text, 16px icons.
        \value Toggle.Sm 24px, 10px text, 12px icons.
        \value Toggle.Lg 32px.

        \note \c Default is listed first so it shares value 0 with \l Variant's
        \c Default; QML flattens enum values into the type scope, so a colliding
        name must resolve to the same number in both enums.
    */
    enum Size { Default, Sm, Lg }

    /*!
        \qmlproperty int Toggle::variant
        The visual style; see \l Variant. Defaults to \c Toggle.Default.
    */
    property int variant: Toggle.Default
    /*!
        \qmlproperty int Toggle::size
        The size on the compact scale; see \l Size. Defaults to \c Toggle.Default.
    */
    property int size: Toggle.Default
    /*!
        \qmlproperty string Toggle::iconName
        Optional leading Lucide icon (kebab-case name).
    */
    property string iconName: ""

    checkable: true

    // Square min side / height (mira: sm 24, default 28, lg 32).
    readonly property real _dim: size === Toggle.Sm ? 24 : size === Toggle.Lg ? 32 : 28
    // Icon px: sm size-3 (12), otherwise size-4 (16).
    readonly property int _iconSize: size === Toggle.Sm ? 12 : 16
    // Text: sm text-[0.625rem] (10), otherwise text-xs (12).
    readonly property int _textSize: size === Toggle.Sm ? 10 : Theme.textXs
    // rounded-md (sm's rounded-[min(radius-md,8px)] also resolves to radiusMd).
    readonly property real _radius: Theme.radiusMd
    // Horizontal padding: lg px-2.5 (10), otherwise px-2 (8); the icon side loses 2 (pl-1.5).
    readonly property real _hpad: size === Toggle.Lg ? Theme.space2_5 : Theme.space2

    readonly property bool _hasText: text !== ""

    implicitHeight: _dim
    implicitWidth: Math.max(contentItem.implicitWidth + leftPadding + rightPadding, _dim)

    padding: 0
    leftPadding: _hpad - (iconName !== "" ? 2 : 0)
    rightPadding: _hpad
    font.pixelSize: _textSize
    font.weight: Font.Medium
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // Tab-focusable; Space/Enter toggling comes from AbstractButton
    opacity: enabled ? 1.0 : 0.5

    contentItem: Item {
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: Theme.space1 // gap-1

            LucideIcon {
                visible: control.iconName !== ""
                name: control.iconName
                size: control._iconSize
                color: Theme.foreground
            }
            Text {
                visible: control._hasText
                text: control.text
                font.pixelSize: control.font.pixelSize
                font.weight: control.font.weight
                color: Theme.foreground
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }
    }

    background: Rectangle {
        radius: control._radius
        border.width: control.variant === Toggle.Outline ? 1 : 0
        border.color: Theme.input
        // Checked or hovered -> bg-muted; otherwise transparent.
        color: (control.checked || control.hovered) ? Theme.muted : Theme.alpha(Theme.muted, 0)
        Behavior on color { ColorAnimation { duration: Theme.durBase } }

        FocusRing { active: control.visualFocus; targetRadius: control._radius }
    }
}
