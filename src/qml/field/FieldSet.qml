import QtQuick
import QtQuick.Layouts

/*!
    \qmltype FieldSet
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief A semantic grouping (<fieldset>, flex-col, gap-4).

    Typically contains a \l FieldLegend, a \l FieldDescription and a
    \l FieldGroup.
*/
ColumnLayout {
    Layout.fillWidth: true
    spacing: Theme.space4        // gap-4
}
