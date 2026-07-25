import QtQuick
import QtQuick.Layouts

/*!
    \qmltype FieldGroup
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief Stacks a set of \l Field items in a column (gap-4).

    Place a \l FieldSeparator between fields when a divider is needed.
*/
ColumnLayout {
    Layout.fillWidth: true
    spacing: Theme.space4        // gap-4
}
