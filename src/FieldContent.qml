import QtQuick
import QtQuick.Layouts

/*!
    \qmltype FieldContent
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief Collects a label and description into a single column beside a
    control.

    Used when a title/label and its description must stack together next to a
    control (for example a switch or checkbox card). Fills the available width
    (flex-1) and spaces children with gap-0.5. Omit it when there is no
    description.
*/
ColumnLayout {
    Layout.fillWidth: true
    spacing: Theme.space0_5      // gap-0.5
}
