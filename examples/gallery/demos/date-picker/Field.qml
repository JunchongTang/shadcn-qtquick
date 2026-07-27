import QtQuick
import QtQuick.Layouts
import Shadcn

// Official date-picker-basic: a date picker wrapped in a Field (label + control), width w-44, align="start".
// Note: the library has no Field/FieldLabel component yet, so this reproduces it with a vertical Label + DatePicker composition (gap-2).
ColumnLayout {
    id: field
    width: 176                       // w-44
    spacing: Theme.space2            // Field gap ≈ gap-2

    Label {
        text: qsTr("Date")                 // FieldLabel
    }

    DatePicker {
        Layout.fillWidth: true
        placeholder: qsTr("Pick a date")
        align: Popover.Align.Start
    }
}
