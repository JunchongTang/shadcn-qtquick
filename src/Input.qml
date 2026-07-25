import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype Input
    \inqmlmodule Shadcn
    \inherits TextField
    \brief Single-line text field matching shadcn/ui's base-mira \c Input.
    \image input.png


    Input is a compact (\c h-7 / 28px) text field with an \c {input/20} tinted
    fill, a 1px \c border-input outline, and the shared base-mira focus-visible
    ring (\l FocusRing). It maps the base-mira \c {.cn-input} utility: on focus
    the border turns to \c Theme.ring and the ring appears; when \l invalid it
    turns to \c Theme.destructive with a destructive tint ring. Being a plain
    \l {QtQuick.Controls.Basic}{TextField}, it inherits the full text-editing API
    (\c text, \c placeholderText, \c echoMode, \c readOnly, \c validator, ...).

    Per repo convention for text inputs, the focus ring is gated on \c activeFocus
    (it appears on any focus, including a mouse click), unlike button-like controls
    which gate on \c visualFocus (keyboard only). \c focusPolicy is
    \c Qt.StrongFocus so the field is reachable by both click and Tab.

    When placed inside a \l ButtonGroup, the group assigns \l groupPosition and
    \l groupVertical so the inner corners adjacent to neighbours are straightened
    (the focus ring follows the same per-corner radii).

    \qml
    Input { placeholder: "Enter text"; placeholderText: "Enter text" }
    Input { invalid: true; placeholderText: "Error" }
    \endqml
*/
C.TextField {
    id: control

    /*! \qmlproperty bool Input::invalid
        Marks the field as failing validation (maps \c {aria-invalid}).
        When \c true the border and ring switch to the destructive color.
        Defaults to \c false. */
    property bool invalid: false

    /*! \qmlproperty enumeration Input::groupPosition
        Adjacency of this field inside a \l ButtonGroup; reuses
        \l {Button::}{Button.GroupPosition}. Set automatically by ButtonGroup to
        straighten the corners shared with neighbours.

        \value Button.GroupNone Standalone; all corners rounded (default).
        \value Button.GroupFirst First item; keeps the outer leading corners round.
        \value Button.GroupMiddle Interior item; all corners straightened.
        \value Button.GroupLast Last item; keeps the outer trailing corners round. */
    property int groupPosition: Button.GroupNone

    /*! \qmlproperty bool Input::groupVertical
        Whether the containing \l ButtonGroup is vertical. Set by ButtonGroup.
        Defaults to \c false. */
    property bool groupVertical: false

    implicitHeight: 28              // h-7
    leftPadding: Theme.space2       // px-2
    rightPadding: Theme.space2
    topPadding: 0
    bottomPadding: 0
    font.pixelSize: Theme.textXs    // md:text-xs
    color: Theme.foreground
    placeholderTextColor: Theme.mutedForeground
    selectionColor: Theme.alpha(Theme.primary, 0.35)
    selectedTextColor: Theme.foreground
    verticalAlignment: TextInput.AlignVCenter

    // Reachable by click and Tab; the ring is gated on activeFocus below.
    focusPolicy: Qt.StrongFocus
    // disabled:opacity-50 (interaction is disabled via enabled by the consumer).
    opacity: enabled ? 1.0 : 0.5

    // Lift above neighbours while focused (focus-visible:z-10) so the ring-colored
    // border covers the edge shared with an adjacent item (spacing:-1); otherwise
    // the later-painted neighbour border would hide it, desyncing the colors.
    z: activeFocus ? 10 : 0

    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        // Straighten the corners adjacent to group neighbours (per-corner, same
        // mechanism as Button).
        readonly property bool _n: control.groupPosition === Button.GroupNone
        readonly property bool _f: control.groupPosition === Button.GroupFirst
        readonly property bool _l: control.groupPosition === Button.GroupLast
        readonly property bool _v: control.groupVertical
        topLeftRadius:     (_n || _f) ? radius : 0
        bottomRightRadius: (_n || _l) ? radius : 0
        topRightRadius:    (_n || (!_v && _l) || (_v && _f)) ? radius : 0
        bottomLeftRadius:  (_n || (!_v && _f) || (_v && _l)) ? radius : 0
        // bg-input/20 dark:bg-input/30
        color: Theme.alpha(Theme.input, Theme.dark ? 0.3 : 0.2)
        border.width: 1
        // border-input, focus-visible:border-ring, aria-invalid:border-destructive
        // (dark:aria-invalid:border-destructive/50). invalid wins over focus.
        border.color: control.invalid
                        ? (Theme.dark ? Theme.alpha(Theme.destructive, 0.5) : Theme.destructive)
                     : control.activeFocus ? Theme.ring : Theme.input
        Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid ring: ring-destructive/20 (dark:ring-destructive/40),
        // shown whenever invalid regardless of focus.
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: bg.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.destructive, Theme.dark ? 0.4 : 0.2)
            visible: control.invalid
            z: -1
        }

        // Focus-visible ring, per-corner rounded to match the background (a
        // group-straightened side stays square). Suppressed while invalid so the
        // destructive ring above is the only one shown (aria-invalid wins in base).
        FocusRing {
            active: control.activeFocus && !control.invalid
            targetRadius: bg.radius
            targetTopLeft: bg.topLeftRadius
            targetTopRight: bg.topRightRadius
            targetBottomLeft: bg.bottomLeftRadius
            targetBottomRight: bg.bottomRightRadius
        }
    }
}
