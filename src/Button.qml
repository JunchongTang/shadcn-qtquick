import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import LucideIcons

/*!
    \qmltype Button
    \inqmlmodule Shadcn
    \inherits Button
    \brief A compact, variant-driven push button styled after shadcn/ui base-mira.

    Button is the foundational action control. It wraps the Qt Quick Controls
    \c Button and paints a background/label following the base-mira
    \c .cn-button-* rules. Pick the look with \l variant and the compact size
    scale with \l size; both default to \c Button.Default.

    The control supports leading and trailing Lucide icon slots (\l iconName,
    \l trailingIconName), an icon-only mode (the \c Icon* sizes), a \l loading
    spinner, a full-radius \l rounded (pill) mode, and corner-straightening when
    placed inside a ButtonGroup via \l groupPosition / \l groupVertical.

    The keyboard focus ring is gated on \c visualFocus, so it only appears for
    Tab focus (focus-visible), not for mouse clicks; \c focusPolicy is
    \c Qt.StrongFocus so the button also takes focus on click (mirroring the web
    behaviour of blurring the previously focused input).

    \qml
    Button { text: "Submit"; trailingIconName: "arrow-right" }
    Button { variant: Button.Outline; text: "Cancel" }
    Button { variant: Button.Destructive; text: "Delete" }
    Button { size: Button.Icon; iconName: "arrow-right" }
    \endqml

    \sa ButtonGroup, Toggle
*/
// Base class alias import (as C) keeps the file's own type name `Button`
// available for enum access (e.g. Button.Default) inside this file.
C.Button {
    id: control

    /*!
        \qmlproperty enumeration Button::variant
        Visual style. \c Default is listed first so it holds value 0.
        \value Button.Default Solid primary background, primary-foreground text.
        \value Button.Secondary Solid secondary background, secondary-foreground text.
        \value Button.Outline Transparent fill with a 1px border-colored outline.
        \value Button.Ghost Transparent fill, muted background on hover.
        \value Button.Destructive Translucent destructive fill, destructive text.
        \value Button.Link Text-only, primary color, underline on hover.
    */
    enum Variant { Default, Secondary, Outline, Ghost, Destructive, Link }

    /*!
        \qmlproperty enumeration Button::size
        Compact size scale (height in px). \c Default is listed first so it holds
        value 0, matching \l Variant's \c Default (QML flattens enum values into
        the type scope, so a shared name must resolve to the same number).
        \value Button.Default 28px, 12px text, 14px icons, px-2.
        \value Button.Sm 24px, 12px text, 12px icons, px-2.
        \value Button.Lg 32px, 12px text, 16px icons, px-2.5.
        \value Button.Xs 20px, 10px text, 10px icons, px-2, smaller radius.
        \value Button.Icon 28px square, icon-only.
        \value Button.IconSm 24px square, icon-only.
        \value Button.IconXs 20px square, icon-only, smaller radius.
        \value Button.IconLg 32px square, icon-only.
    */
    enum Size { Default, Sm, Lg, Xs, Icon, IconSm, IconXs, IconLg }

    /*!
        \qmlproperty enumeration Button::groupPosition
        Adjacency inside a ButtonGroup, which decides which corners are
        straightened. Set automatically by ButtonGroup.
        \value Button.GroupNone Standalone; all corners rounded.
        \value Button.GroupFirst First item; keeps the outer leading corners round.
        \value Button.GroupMiddle Interior item; all corners straightened.
        \value Button.GroupLast Last item; keeps the outer trailing corners round.
    */
    enum GroupPosition { GroupNone, GroupFirst, GroupMiddle, GroupLast }

    /*!
        \qmlproperty int Button::variant
        The visual style; see \l Variant. Defaults to \c Button.Default.
    */
    property int variant: Button.Default
    /*!
        \qmlproperty int Button::size
        The size on the compact scale; see \l Size. Defaults to \c Button.Default.
    */
    property int size: Button.Default
    /*!
        \qmlproperty string Button::iconName
        Optional leading Lucide icon (kebab-case name).
    */
    property string iconName: ""
    /*!
        \qmlproperty string Button::trailingIconName
        Optional trailing Lucide icon (kebab-case name).
    */
    property string trailingIconName: ""
    /*!
        \qmlproperty bool Button::rounded
        When true, uses a full (pill) radius (rounded-full).
    */
    property bool rounded: false
    /*!
        \qmlproperty bool Button::loading
        When true, shows a leading Spinner and disables interaction.
    */
    property bool loading: false
    /*!
        \qmlproperty int Button::groupPosition
        Adjacency inside a ButtonGroup; see \l GroupPosition. Set by ButtonGroup.
    */
    property int groupPosition: Button.GroupNone
    /*!
        \qmlproperty bool Button::groupVertical
        Whether the containing ButtonGroup is vertical. Set by ButtonGroup.
    */
    property bool groupVertical: false

    // Disable interaction while loading (a consumer setting enabled explicitly
    // overrides this binding).
    enabled: !loading

    readonly property bool _iconOnly: size === Button.Icon || size === Button.IconSm
                                   || size === Button.IconXs || size === Button.IconLg

    // Height / square side (mira: xs 20, sm 24, default 28, lg 32; icon sizes match).
    readonly property real _dim: {
        switch (size) {
        case Button.Xs: case Button.IconXs: return 20
        case Button.Sm: case Button.IconSm: return 24
        case Button.Lg: case Button.IconLg: return 32
        case Button.Icon: return 28
        default: return 28 // Default
        }
    }
    // Icon px (svg size-*): xs 10, sm 12, default 14, lg 16.
    readonly property int _iconSize: {
        switch (size) {
        case Button.Xs: case Button.IconXs: return 10
        case Button.Sm: case Button.IconSm: return 12
        case Button.Lg: case Button.IconLg: return 16
        case Button.Icon: return 14
        default: return 14 // Default
        }
    }
    // Text px: xs text-[0.625rem] (10), otherwise text-xs (12).
    readonly property int _textSize: size === Button.Xs ? 10 : Theme.textXs
    // Corner radius: xs / icon-xs use rounded-sm, otherwise rounded-md.
    readonly property real _radius: (size === Button.Xs || size === Button.IconXs)
                                    ? Theme.radiusSm : Theme.radiusMd
    // Effective radius: pill when rounded, otherwise the size radius.
    readonly property real _effRadius: rounded ? Theme.radiusFull : _radius
    // Horizontal padding: lg px-2.5 (10), otherwise px-2 (8). The icon side loses
    // 2px (pl-1.5 / pr-1.5) when an icon or spinner sits on that side.
    readonly property real _hpad: size === Button.Lg ? Theme.space2_5 : Theme.space2

    implicitHeight: _dim
    implicitWidth: _iconOnly ? _dim
                             : Math.max(contentItem.implicitWidth + leftPadding + rightPadding, _dim)

    padding: 0
    leftPadding: _iconOnly ? 0 : _hpad - ((iconName !== "" || loading) ? 2 : 0)
    rightPadding: _iconOnly ? 0 : _hpad - (trailingIconName !== "" ? 2 : 0)
    font.pixelSize: _textSize
    font.weight: Font.Medium
    hoverEnabled: true
    // Take focus on click too (mirrors web: clicking a button blurs the focused
    // input). The ring is gated on visualFocus below, so a click never shows it;
    // only keyboard (Tab) focus does (= focus-visible).
    focusPolicy: Qt.StrongFocus
    opacity: enabled ? 1.0 : 0.5

    // Foreground (text/icon) color per variant.
    readonly property color _fg: {
        switch (variant) {
        case Button.Default: return Theme.primaryForeground
        case Button.Secondary: return Theme.secondaryForeground
        case Button.Destructive: return Theme.destructive
        case Button.Link: return Theme.primary
        default: return Theme.foreground // Outline / Ghost
        }
    }

    contentItem: Item {
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight
        // active:translate-y-px -- content sinks 1px while pressed.
        transform: Translate { y: control.down ? 1 : 0 }

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: Theme.space1 // gap-1

            Spinner {
                visible: control.loading
                size: control._iconSize
                color: control._fg
            }
            LucideIcon {
                visible: control.iconName !== "" && !control.loading
                name: control.iconName
                size: control._iconSize
                color: control._fg
            }
            Text {
                visible: !control._iconOnly && control.text !== ""
                text: control.text
                font.pixelSize: control.font.pixelSize
                font.weight: control.font.weight
                font.underline: control.variant === Button.Link && control.hovered
                color: control._fg
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            LucideIcon {
                visible: control.trailingIconName !== ""
                name: control.trailingIconName
                size: control._iconSize
                color: control._fg
            }
        }
    }

    background: Rectangle {
        id: bg
        radius: control._effRadius
        // Straighten the inner corners adjacent to neighbours when grouped.
        // Horizontal: First keeps its left, Last keeps its right. Vertical:
        // First keeps its top, Last keeps its bottom. Middle is fully square;
        // None is fully round. Derived per corner (_r = effective radius).
        readonly property real _r: control._effRadius
        readonly property bool _n: control.groupPosition === Button.GroupNone
        readonly property bool _f: control.groupPosition === Button.GroupFirst
        readonly property bool _l: control.groupPosition === Button.GroupLast
        readonly property bool _v: control.groupVertical
        topLeftRadius:     (_n || _f) ? _r : 0
        bottomRightRadius: (_n || _l) ? _r : 0
        topRightRadius:    (_n || (!_v && _l) || (_v && _f)) ? _r : 0
        bottomLeftRadius:  (_n || (!_v && _f) || (_v && _l)) ? _r : 0
        border.width: control.variant === Button.Outline ? 1 : 0
        border.color: Theme.border
        transform: Translate { y: control.down ? 1 : 0 }
        color: {
            switch (control.variant) {
            case Button.Default:
                return control.hovered ? Theme.alpha(Theme.primary, 0.8) : Theme.primary
            case Button.Secondary:
                return control.hovered ? Qt.darker(Theme.secondary, 1.05) : Theme.secondary
            case Button.Destructive:
                return Theme.alpha(Theme.destructive, control.hovered ? 0.2 : 0.1)
            case Button.Outline:
                return control.hovered ? Theme.alpha(Theme.input, 0.5) : Theme.alpha(Theme.input, 0)
            case Button.Ghost:
                return control.hovered ? Theme.muted : Theme.alpha(Theme.muted, 0)
            default:
                return "transparent" // Link
            }
        }

        // Keyboard-only focus-visible ring (a mouse click that takes focus does
        // not show it). The ring follows the background's per-corner radii, so a
        // corner straightened inside a group gets a square ring corner too.
        FocusRing {
            active: control.visualFocus
            targetRadius: control._effRadius
            targetTopLeft: bg.topLeftRadius
            targetTopRight: bg.topRightRadius
            targetBottomLeft: bg.bottomLeftRadius
            targetBottomRight: bg.bottomRightRadius
        }
    }
}
