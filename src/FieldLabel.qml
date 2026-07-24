import QtQuick
import QtQuick.Layouts

/*!
    \qmltype FieldLabel
    \inqmlmodule Shadcn
    \inherits Label
    \brief A field label built on \l Label (text-xs, medium, dims when disabled).

    Uses leading-snug and wraps; fills the available width so that in a
    horizontal field it pushes the control to the right (flex-auto). For a
    choice card (a \l Field wrapped inside a FieldLabel) the border, radius and
    checked background are restored by the demo's card container.

    \qmlproperty bool FieldLabel::invalid
    When true the label turns destructive to track \l {Field::invalid}.
*/
Label {
    property bool invalid: false        // turn destructive with Field.invalid

    Layout.fillWidth: true
    color: invalid ? Theme.destructive : Theme.foreground
    wrapMode: Text.Wrap
    horizontalAlignment: Text.AlignLeft
    lineHeight: 1.375                    // leading-snug
    lineHeightMode: Text.ProportionalHeight
}
