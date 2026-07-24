import QtQuick
import QtQuick.Controls.Basic as C
import LucideIcons

/*!
    \qmltype IconButton
    \inqmlmodule Shadcn
    \inherits Button
    \brief A compact, square, icon-only button styled after shadcn/ui base-mira.

    IconButton is the icon-only counterpart of \l Button: it corresponds to
    shadcn's \c Button used with the \c size="icon*" variants, rendering a single
    centered Lucide icon inside a square background. Pick the look with \l variant
    and the compact square scale with \l size.

    The variants mirror \l Button (Default / Secondary / Outline / Ghost /
    Destructive), so the background and foreground colors stay consistent across
    the two controls. Unlike \l Button, IconButton defaults to \c IconButton.Ghost,
    the usual look for toolbar-style icon actions.

    The three sizes map onto \l Button's icon sizes: \c Small = 24px (icon-sm),
    \c Medium = 28px (icon), \c Large = 32px (icon-lg); the icon glyph is
    12 / 14 / 16px respectively. All sizes use the \c rounded-md corner radius.

    The keyboard focus ring is gated on \c visualFocus, so it only appears for
    Tab focus (focus-visible), not for mouse clicks; \c focusPolicy is
    \c Qt.StrongFocus so the button also takes focus on click (mirroring the web
    behaviour of blurring the previously focused input).

    \qml
    IconButton { iconName: "settings" }
    IconButton { variant: IconButton.Outline; size: IconButton.Small; iconName: "x" }
    IconButton { variant: IconButton.Destructive; iconName: "trash-2" }
    \endqml

    \sa Button, Toggle
*/
// Base class alias import (as C) keeps the file's own type name `IconButton`
// available for enum access (e.g. IconButton.Ghost) inside this file.
C.Button {
    id: control

    /*!
        \qmlproperty enumeration IconButton::variant
        Visual style, matching \l Button's variants for cross-control consistency.
        \c Default is listed first so it holds value 0.
        \value IconButton.Default Solid primary background, primary-foreground icon.
        \value IconButton.Secondary Solid secondary background, secondary-foreground icon.
        \value IconButton.Outline Transparent fill with a 1px border-colored outline.
        \value IconButton.Ghost Transparent fill, muted background on hover (the default).
        \value IconButton.Destructive Translucent destructive fill, destructive icon.
    */
    enum Variant { Default, Secondary, Outline, Ghost, Destructive }

    /*!
        \qmlproperty enumeration IconButton::size
        Compact square scale (side length in px). These map onto \l Button's
        icon sizes; all use the \c rounded-md corner radius.
        \value IconButton.Small 24px square, 12px icon (= Button.IconSm).
        \value IconButton.Medium 28px square, 14px icon (= Button.Icon), the default.
        \value IconButton.Large 32px square, 16px icon (= Button.IconLg).
    */
    enum Size { Small, Medium, Large }

    /*! \qmlproperty int IconButton::variant \brief The visual style; see \l Variant. Defaults to \c IconButton.Ghost. */
    property int variant: IconButton.Ghost
    /*! \qmlproperty int IconButton::size \brief The square size; see \l Size. Defaults to \c IconButton.Medium. */
    property int size: IconButton.Medium
    /*! \qmlproperty string IconButton::iconName \brief The Lucide icon to draw (kebab-case name). Named \c iconName because \c Button.icon is FINAL and cannot be shadowed. */
    property string iconName: ""

    // Square side: icon-sm 24 / icon 28 / icon-lg 32.
    implicitHeight: size === IconButton.Small ? 24 : size === IconButton.Large ? 32 : 28
    implicitWidth: implicitHeight
    // Icon glyph (svg size-*): sm 12 / default 14 / lg 16.
    readonly property int _iconSize: size === IconButton.Small ? 12 : size === IconButton.Large ? 16 : 14
    padding: 0
    hoverEnabled: true
    // Take focus on click too (mirrors web: clicking a button blurs the focused
    // input). The ring is gated on visualFocus below, so a click never shows it;
    // only keyboard (Tab) focus does (= focus-visible).
    focusPolicy: Qt.StrongFocus
    opacity: enabled ? 1.0 : 0.5

    // Foreground (icon) color per variant, matching Button.
    readonly property color _fg: {
        switch (variant) {
        case IconButton.Default: return Theme.primaryForeground
        case IconButton.Secondary: return Theme.secondaryForeground
        case IconButton.Destructive: return Theme.destructive
        default: return Theme.foreground   // Outline / Ghost
        }
    }

    contentItem: Item {
        // active:translate-y-px -- the icon sinks 1px while pressed.
        transform: Translate { y: control.down ? 1 : 0 }
        LucideIcon {
            anchors.centerIn: parent
            name: control.iconName
            size: control._iconSize
            color: control._fg
        }
    }

    background: Rectangle {
        radius: Theme.radiusMd
        border.width: control.variant === IconButton.Outline ? 1 : 0
        border.color: Theme.border
        transform: Translate { y: control.down ? 1 : 0 }
        color: {
            switch (control.variant) {
            case IconButton.Default:
                return control.hovered ? Theme.alpha(Theme.primary, 0.8) : Theme.primary
            case IconButton.Secondary:
                return control.hovered ? Qt.darker(Theme.secondary, 1.05) : Theme.secondary
            case IconButton.Destructive:
                return Theme.alpha(Theme.destructive, control.hovered ? 0.2 : 0.1)
            case IconButton.Outline:
                return control.hovered ? Theme.alpha(Theme.input, 0.5) : Theme.alpha(Theme.input, 0)
            default: // Ghost
                return control.hovered ? Theme.muted : Theme.alpha(Theme.muted, 0)
            }
        }
        Behavior on color { ColorAnimation { duration: Theme.durBase } }

        // Keyboard-only focus-visible ring (a mouse click that takes focus does
        // not show it). Radius matches the background's rounded-md.
        FocusRing { active: control.visualFocus; targetRadius: Theme.radiusMd }
    }
}
