import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype Switch
    \inqmlmodule Shadcn
    \inherits Switch
    \brief A capsule toggle with a sliding circular thumb.

    Switch ports shadcn/ui's \c base-mira switch (\c .cn-switch /
    \c .cn-switch-thumb): a pill-shaped track whose fill is the primary color
    when checked and the input color when unchecked, with a circular thumb that
    slides between the two ends.

    The public API mirrors the underlying \l {QtQuick.Controls}{Switch}, so
    \c checked toggles the state as usual. Use \l size for the compact size
    scale and \l invalid for the destructive (\c aria-invalid) form styling.

    \qml
    Switch {}
    Switch { checked: true }
    Switch { size: Switch.Sm }
    Switch { invalid: true }
    \endqml

    \sa Checkbox, Toggle
*/
C.Switch {
    id: control

    /*!
        \qmlproperty enumeration Switch::size
        Compact size scale (matches \c data-[size]):
        \value Switch.Default 28x16.6px track, 14px thumb (\c size-3.5).
        \value Switch.Sm 24x14px track, 12px thumb (\c size-3).
    */
    enum Size { Default, Sm }

    /*! \qmlproperty int Switch::size \brief The size on the compact scale; see \l Size. Defaults to \c Switch.Default. */
    property int size: Switch.Default
    /*!
        \qmlproperty bool Switch::invalid
        \brief Whether the control is in the invalid (\c aria-invalid) state.

        When \c true the track gains a destructive border and a faint
        destructive ring, matching the reference's
        \c {aria-invalid:border-destructive aria-invalid:ring-destructive/20}.
    */
    property bool invalid: false

    // Track dimensions: default h-[16.6px] w-[28px]; sm h-[14px] w-[24px].
    readonly property real _w: size === Switch.Sm ? 24 : 28
    readonly property real _h: size === Switch.Sm ? 14 : 17     // h-[16.6px] rounds to 17
    // Thumb: default size-3.5 (14), sm size-3 (12).
    readonly property real _thumb: size === Switch.Sm ? 12 : 14

    implicitWidth: _w
    implicitHeight: _h
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // Tab-focusable; Space/Enter toggling comes from AbstractButton
    opacity: enabled ? 1.0 : 0.5    // data-disabled:opacity-50

    indicator: Rectangle {
        id: track
        objectName: "track"
        implicitWidth: control._w
        implicitHeight: control._h
        radius: height / 2          // rounded-full
        // Checked -> bg-primary; unchecked -> bg-input (dark: bg-input/80).
        color: control.checked ? Theme.primary
                               : (Theme.dark ? Theme.alpha(Theme.input, 0.8) : Theme.input)
        // Reference keeps a 1px border ("border border-transparent"); it turns
        // destructive on aria-invalid. The transparent border also defines the
        // 1px inset the thumb rests against.
        border.width: 1
        border.color: control.invalid ? Theme.destructive : "transparent"
        Behavior on color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid ring: destructive/20 (light), destructive/40 (dark).
        Rectangle {
            objectName: "invalidRing"
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: track.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.destructive, Theme.dark ? 0.4 : 0.2)
            visible: control.invalid
            z: -1
        }

        Rectangle {
            id: thumb
            objectName: "thumb"
            width: control._thumb
            height: control._thumb
            radius: height / 2
            y: (parent.height - height) / 2
            // Slides between the two ends, resting against the 1px track border.
            // checked translates by (thumb - 2) from x=1 -> x = width - thumb - 1.
            x: control.checked ? parent.width - width - 1 : 1
            // bg-background (light); dark: unchecked bg-foreground, checked bg-primary-foreground.
            color: Theme.dark ? (control.checked ? Theme.primaryForeground : Theme.foreground)
                              : Theme.background
            Behavior on x { NumberAnimation { duration: Theme.durFast; easing.type: Easing.OutCubic } }
        }

        FocusRing { active: control.visualFocus; targetRadius: track.radius }
    }
}
