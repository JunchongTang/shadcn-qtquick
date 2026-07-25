import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype RangeSlider
    \inqmlmodule Shadcn
    \inherits RangeSlider
    \brief A two-thumb slider for selecting a value range.

    RangeSlider ports shadcn's base-mira \c .cn-slider styling for the two-thumb
    usage (\c {defaultValue={[a, b]}}). It shares the exact visuals of the
    single-value \l Slider: a \c bg-muted, \c rounded-md track (\c h-1 / 4px when
    horizontal, \c w-1 / 4px when vertical) with a \c bg-primary indicator painted
    \e between the two thumbs, plus \c size-3 (12px), \c rounded-md, white thumbs
    with a \c border-ring outline that grow a focus ring on hover, press, or
    keyboard focus.

    It is built on the Qt Quick Controls \c RangeSlider, so the two ends are the
    \c first and \c second nodes; read and write the selected range through
    \c first.value and \c second.value.

    \qml
    RangeSlider { from: 0; to: 100; first.value: 25; second.value: 75 }
    \endqml

    \sa Slider
*/
C.RangeSlider {
    id: control

    /*!
        \qmlproperty real RangeSlider::from
        Range minimum. Defaults to \c 0.
    */
    from: 0
    /*!
        \qmlproperty real RangeSlider::to
        Range maximum. Defaults to \c 100.
    */
    to: 100
    /*!
        \qmlproperty real RangeSlider::stepSize
        Keyboard/drag increment. Defaults to \c 1.
    */
    stepSize: 1

    /*!
        \qmlproperty real RangeSlider::first.value
        Value of the lower (first) thumb.

        Defaults to \l from so a bare RangeSlider spans the full range, matching
        shadcn's base \c <Slider>, which falls back to \c {[min, max]}. (Qt's own
        default of \c 1.0 for \c second.value would otherwise collapse the range
        against \c from.)
    */
    first.value: from
    /*!
        \qmlproperty real RangeSlider::second.value
        Value of the upper (second) thumb. Defaults to \l to; see \l first.value.
    */
    second.value: to

    /*!
        \qmlproperty enumeration RangeSlider::orientation
        Layout direction.
        \value Qt.Horizontal Track runs left-to-right (the default); higher values to the right.
        \value Qt.Vertical Track runs bottom-to-top; higher values upward.
    */
    // Note: C.RangeSlider exposes a read-only FINAL property horizontal
    // (== orientation === Qt.Horizontal).
    implicitWidth: horizontal ? 200 : 12
    implicitHeight: horizontal ? 12 : 160   // vertical default min-h-40 = 160
    padding: 0
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // Tab-focusable; arrow-key stepping comes from the base class
    live: true
    // data-disabled:opacity-50
    opacity: enabled ? 1.0 : 0.5

    // ==== Track (bg-muted) + indicator (bg-primary, between the two thumbs) ====
    background: Rectangle {
        id: track
        x: control.leftPadding + (control.horizontal ? 0 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : 0)
        implicitWidth: control.horizontal ? 200 : 4
        implicitHeight: control.horizontal ? 4 : 160
        width: control.horizontal ? control.availableWidth : 4    // h-1 / w-1
        height: control.horizontal ? 4 : control.availableHeight
        radius: Theme.radiusMd
        color: Theme.muted
        clip: true                                               // overflow-hidden

        Rectangle {
            objectName: "range"
            radius: Theme.radiusMd
            color: Theme.primary
            // Horizontal: from first to second. Vertical: bottom-up, same span
            // between the two nodes (second is the upper/larger-value handle).
            x: control.horizontal ? control.first.position * track.width : 0
            width: control.horizontal
                ? (control.second.position - control.first.position) * track.width
                : track.width
            height: control.horizontal
                ? track.height
                : (control.second.position - control.first.position) * track.height
            y: control.horizontal ? 0 : track.height - control.second.position * track.height
        }
    }

    // ==== First thumb (rounded-md white fill + ring outline + focus ring) ====
    first.handle: Rectangle {
        id: firstThumb
        x: control.leftPadding + (control.horizontal
            ? control.first.visualPosition * (control.availableWidth - width)
            : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal
            ? (control.availableHeight - height) / 2
            : control.first.visualPosition * (control.availableHeight - height))
        implicitWidth: 12                                        // size-3
        implicitHeight: 12
        radius: Theme.radiusMd
        color: "#ffffff"                                         // bg-white (identical in light/dark)
        border.width: 1
        border.color: Theme.ring                                 // border-ring

        // hover:ring-2 / active(pressed):ring-2 / focus-visible:ring-2 (ring/30).
        // control.visualFocus is keyboard-only; gating on this handle's own
        // activeFocus keeps the keyboard ring on the focused thumb only (rather
        // than lighting both thumbs), while hover/press cover mouse interaction.
        FocusRing {
            active: control.first.hovered || control.first.pressed
                    || (control.visualFocus && firstThumb.activeFocus)
            targetRadius: firstThumb.radius
        }
    }

    // ==== Second thumb ====
    second.handle: Rectangle {
        id: secondThumb
        x: control.leftPadding + (control.horizontal
            ? control.second.visualPosition * (control.availableWidth - width)
            : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal
            ? (control.availableHeight - height) / 2
            : control.second.visualPosition * (control.availableHeight - height))
        implicitWidth: 12
        implicitHeight: 12
        radius: Theme.radiusMd
        color: "#ffffff"
        border.width: 1
        border.color: Theme.ring

        FocusRing {
            active: control.second.hovered || control.second.pressed
                    || (control.visualFocus && secondThumb.activeFocus)
            targetRadius: secondThumb.radius
        }
    }
}
