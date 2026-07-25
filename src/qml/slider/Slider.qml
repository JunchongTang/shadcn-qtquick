import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype Slider
    \inqmlmodule Shadcn
    \inherits QtQuick.Controls.Slider
    \brief A single-thumb slider for picking one value from a range.
    \image slider.png


    Slider ports shadcn's base-mira \c .cn-slider styling for the single-value
    usage (\c {defaultValue={n}}). It shares the exact visuals of the two-thumb
    \l RangeSlider: a \c bg-muted, \c rounded-md track (\c h-1 / 4px when
    horizontal, \c w-1 / 4px when vertical) with a \c bg-primary indicator filled
    from the start of the track up to the current value, plus a \c size-3 (12px),
    \c rounded-md, white thumb with a \c border-ring outline that grows a focus
    ring on hover, press, or keyboard focus.

    It is built on the Qt Quick Controls \c Slider, so the selected value is read
    and written through \l value.

    \qml
    Slider { from: 0; to: 100; value: 50 }
    Slider { orientation: Qt.Vertical; value: 25 }
    \endqml

    \sa RangeSlider
*/
C.Slider {
    id: control

    /*!
        \qmlproperty real Slider::from
        Range minimum. Defaults to \c 0.
    */
    from: 0
    /*!
        \qmlproperty real Slider::to
        Range maximum. Defaults to \c 100.
    */
    to: 100
    /*!
        \qmlproperty real Slider::stepSize
        Keyboard/drag increment. Defaults to \c 1.
    */
    stepSize: 1

    /*!
        \qmlproperty real Slider::value
        The currently selected value, clamped to \l from .. \l to.

        A bare Slider defaults to \l from (\c 0), i.e. an empty indicator with the
        thumb at the start of the track; this matches Qt's own default and is the
        sane single-thumb equivalent of \l RangeSlider's full-range fallback.
    */

    /*!
        \qmlproperty enumeration Slider::orientation
        Layout direction.
        \value Qt.Horizontal Track runs left-to-right (the default); higher values to the right.
        \value Qt.Vertical Track runs bottom-to-top; higher values upward.
    */
    // Note: C.Slider exposes a read-only FINAL property horizontal
    // (== orientation === Qt.Horizontal); use control.horizontal directly.

    implicitWidth: horizontal ? 200 : 12
    implicitHeight: horizontal ? 12 : 160   // vertical default min-h-40 = 160
    padding: 0
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // Tab-focusable; arrow-key stepping comes from the base class
    live: true
    // data-disabled:opacity-50
    opacity: enabled ? 1.0 : 0.5

    // ==== Track (bg-muted) + indicator (bg-primary, filled up to the value) ====
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
            // Horizontal: fill left-to-right. Vertical: fill bottom-up
            // (a larger value means a taller fill anchored to the bottom).
            width: control.horizontal ? control.position * track.width : track.width
            height: control.horizontal ? track.height : control.position * track.height
            y: control.horizontal ? 0 : track.height - height
        }
    }

    // ==== Thumb (rounded-md white fill + ring outline + focus ring) ====
    handle: Rectangle {
        id: thumb
        x: control.leftPadding + (control.horizontal
            ? control.visualPosition * (control.availableWidth - width)
            : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal
            ? (control.availableHeight - height) / 2
            : control.visualPosition * (control.availableHeight - height))
        implicitWidth: 12                                        // size-3
        implicitHeight: 12
        radius: Theme.radiusMd
        color: "#ffffff"                                         // bg-white (identical in light/dark)
        border.width: 1
        border.color: Theme.ring                                 // border-ring

        // hover:ring-2 / focus-visible:ring-2 / active(pressed):ring-2 (ring/30).
        // Single thumb, so control.visualFocus (keyboard-only) is enough for the
        // focus ring; hover/press cover mouse interaction.
        FocusRing {
            active: control.hovered || control.visualFocus || control.pressed
            targetRadius: thumb.radius
        }
    }
}
