import QtQuick
import QtQuick.Layouts

/*!
    \qmltype FieldTitle
    \inqmlmodule Shadcn
    \inherits Text
    \brief A title inside \l FieldContent with label typography (text-xs/relaxed,
    medium).

    Unlike \l FieldLabel this is not a <label> and is not bound to a control; it
    is used for the title row of choice cards, switches and similar. Dims to
    opacity 0.5 when disabled.

    \qmlproperty bool FieldTitle::invalid
    When true the title turns destructive to track \l {Field::invalid}.
*/
Text {
    property bool invalid: false        // turn destructive with Field.invalid

    Layout.fillWidth: true
    color: invalid ? Theme.destructive : Theme.foreground
    font.pixelSize: Theme.textXs
    font.weight: Font.Medium
    lineHeight: Theme.lineRelaxed
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    opacity: enabled ? 1.0 : 0.5
}
