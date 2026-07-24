import QtQuick
import QtQuick.Layouts

/*!
    \qmltype FieldDescription
    \inqmlmodule Shadcn
    \inherits Text
    \brief Helper text for a field (muted-foreground, text-xs/relaxed).

    \qmlproperty bool FieldDescription::invalid
    When true the text turns destructive to track \l {Field::invalid}. Note the
    base-mira description stays muted-foreground even in the error state; this
    opt-in flag is a convenience used by the gallery validation demos.
*/
Text {
    property bool invalid: false        // turn destructive with Field.invalid

    Layout.fillWidth: true
    color: invalid ? Theme.destructive : Theme.mutedForeground
    font.pixelSize: Theme.textXs
    lineHeight: Theme.lineRelaxed
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    horizontalAlignment: Text.AlignLeft
}
