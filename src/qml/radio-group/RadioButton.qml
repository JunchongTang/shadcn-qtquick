import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype RadioButton
    \inqmlmodule Shadcn
    \inherits QtQuick.Controls.RadioButton
    \brief A compact 16px radio control with an optional trailing label.

    RadioButton ports shadcn/ui's \c base-mira \c RadioGroupItem: a 16x16 circle
    (\c size-4 \c rounded-full) that fills with the primary color and shows a
    small primary-foreground dot (\c size-2) when selected, plus an optional
    label rendered to its right.

    The public API mirrors the underlying \l {QtQuick.Controls::}{RadioButton},
    so \c checked and \c text behave as usual. Radios in the same parent are
    mutually exclusive through Qt's \c autoExclusive (on by default); group them
    with a \l RadioGroup for gap-3 vertical layout, or with a
    \c {QtQuick.Controls.ButtonGroup} for explicit exclusivity.

    The additional \l invalid property renders the destructive (\c aria-invalid)
    styling used in forms.

    \note The filename \c RadioButton matches the base type \c RadioButton, so no
    import alias is required at the call site.

    \sa RadioGroup
*/
C.RadioButton {
    id: control

    /*!
        \qmlproperty bool RadioButton::invalid
        aria-invalid -> destructive border + ring. Defaults to \c false.
    */
    property bool invalid: false

    spacing: Theme.space2
    padding: 0                          // size-4 circle has no surrounding padding
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus         // keyboard-focusable; Space/Enter handled by AbstractButton
    font.pixelSize: Theme.textXs
    opacity: enabled ? 1.0 : 0.5        // disabled:opacity-50

    // Size the control to the circle alone when there is no label, so a
    // label-less radio (e.g. inside a choice card) is exactly 16x16 with no
    // trailing gap; a labelled one grows to fit its text.
    implicitWidth: Math.max(indicator.implicitWidth,
                            text.length > 0 ? contentItem.implicitWidth : 0)
    implicitHeight: Math.max(indicator.implicitHeight,
                             text.length > 0 ? contentItem.implicitHeight : 0)

    indicator: Rectangle {
        id: circle
        implicitWidth: 16                // size-4
        implicitHeight: 16
        x: 0
        y: (control.height - height) / 2
        radius: 8                        // rounded-full
        // Selected: primary fill. Unselected: transparent (light) or
        // bg-input/30 (dark), matching .cn-radio-group-item.
        color: control.checked ? Theme.primary
                               : (Theme.dark ? Theme.alpha(Theme.input, 0.3) : Theme.alpha(Theme.primary, 0))
        border.width: 1
        // Selected keeps the primary border even when invalid
        // (aria-invalid:aria-checked:border-primary). Invalid+unselected turns
        // destructive; keyboard focus turns it to ring.
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
            radius: circle.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.destructive, Theme.dark ? 0.4 : 0.2)
            visible: control.invalid
            z: -1
        }

        // Selected dot (size-2, bg-primary-foreground, rounded-full).
        Rectangle {
            objectName: "indicatorDot"
            anchors.centerIn: parent
            width: 8                     // size-2
            height: 8
            radius: 4
            color: Theme.primaryForeground
            visible: control.checked
        }

        FocusRing { active: control.visualFocus; targetRadius: circle.radius }
    }

    contentItem: Text {
        text: control.text
        visible: control.text.length > 0
        // Offset the label past the circle; collapses to 0 when there is no text.
        leftPadding: control.text.length > 0 ? control.indicator.width + control.spacing : 0
        font: control.font
        color: Theme.foreground
        verticalAlignment: Text.AlignVCenter
    }
}
