import QtQuick
import QtQuick.Layouts

/*!
    \qmltype FieldLegend
    \inqmlmodule Shadcn
    \inherits Text
    \brief The title of a \l FieldSet (font-medium).

    \qmlproperty enumeration FieldLegend::variant
    Type size of the legend.

    \value FieldLegend.Legend Section title, text-sm (default).
    \value FieldLegend.Label Label-sized, text-xs/relaxed; suits a nested FieldSet.
*/
Text {
    enum Variant { Legend, Label }

    property int variant: FieldLegend.Legend

    Layout.fillWidth: true
    color: Theme.foreground
    font.pixelSize: variant === FieldLegend.Label ? Theme.textXs : Theme.textSm
    font.weight: Font.Medium
    lineHeight: variant === FieldLegend.Label ? Theme.lineRelaxed : 1.0
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    horizontalAlignment: Text.AlignLeft
}
