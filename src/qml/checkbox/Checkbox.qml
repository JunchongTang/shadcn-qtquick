import QtQuick
import QtQuick.Controls.Basic as C
import LucideIcons

/*!
    \qmltype Checkbox
    \inqmlmodule Shadcn
    \inherits CheckBox
    \brief A compact 16px check control with an optional trailing label.
    \image checkbox.png


    Checkbox ports shadcn/ui's \c base-mira checkbox: a 16x16 rounded box that
    fills with the primary color and shows a Lucide \c check glyph when checked,
    plus an optional label rendered to its right.

    The public API mirrors the underlying \l CheckBox, so \c checked and \c text
    behave as usual. The additional \l invalid property renders the destructive
    (\c aria-invalid) styling used in forms and tables.

    \note The filename \c Checkbox differs from the base type \c CheckBox only in
    case, so no import alias is required at the call site.
*/
C.CheckBox {
    id: control

    /*!
        \qmlproperty bool Checkbox::invalid
        Whether the control is in the invalid (\c aria-invalid) state.

        When \c true and the box is unchecked, the border turns destructive and a
        faint destructive ring is drawn. A checked box keeps the primary border even
        when invalid, matching the reference's \c aria-invalid:aria-checked:border-primary.
    */
    property bool invalid: false        // aria-invalid -> destructive border + ring

    padding: 0                          // shadcn size-4 box has no surrounding padding
    spacing: Theme.space2
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus         // keyboard-focusable; Space/Enter handled by AbstractButton
    font.pixelSize: Theme.textSm
    opacity: enabled ? 1.0 : 0.5        // disabled:opacity-50

    // The base template derives implicitWidth from the content item (not the
    // indicator). Size the control to the box alone when there is no label, so a
    // label-less checkbox (e.g. in tables) is exactly 16x16 with no trailing gap.
    implicitWidth: Math.max(indicator.implicitWidth,
                            text.length > 0 ? contentItem.implicitWidth : 0)
    implicitHeight: Math.max(indicator.implicitHeight,
                             text.length > 0 ? contentItem.implicitHeight : 0)

    indicator: Rectangle {
        id: box
        implicitWidth: 16               // size-4
        implicitHeight: 16
        x: 0
        y: (control.height - height) / 2
        radius: 4                       // rounded-[4px] (mira fixed value)
        // Unchecked: transparent in light mode, bg-input/30 in dark mode.
        color: control.checked ? Theme.primary
                               : (Theme.dark ? Theme.alpha(Theme.input, 0.3) : Theme.alpha(Theme.primary, 0))
        border.width: 1
        // Checked keeps the primary border even when invalid
        // (aria-invalid:aria-checked:border-primary). Focus turns it to ring.
        border.color: control.checked ? Theme.primary
                     : control.invalid ? (Theme.dark ? Theme.alpha(Theme.destructive, 0.5) : Theme.destructive)
                     : control.visualFocus ? Theme.ring
                     : Theme.input
        Behavior on color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid ring: destructive/20 (light), destructive/40 (dark).
        Rectangle {
            id: invalidRing
            objectName: "invalidRing"
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: box.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.destructive, Theme.dark ? 0.4 : 0.2)
            visible: control.invalid
            z: -1
        }

        // Check glyph.
        LucideIcon {
            objectName: "checkIcon"
            anchors.centerIn: parent
            name: "check"
            size: 14                     // svg size-3.5
            color: Theme.primaryForeground
            visible: control.checked
        }

        FocusRing { active: control.visualFocus; targetRadius: box.radius }
    }

    contentItem: Text {
        text: control.text
        visible: control.text.length > 0
        // Offset the label past the box; collapses to 0 when there is no text.
        leftPadding: control.text.length > 0 ? control.indicator.width + control.spacing : 0
        font: control.font
        color: Theme.foreground
        verticalAlignment: Text.AlignVCenter
    }
}
