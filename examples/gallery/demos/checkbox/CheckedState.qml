import QtQuick
import QtQuick.Layouts
import Shadcn

// Checked / unchecked states —— the checked property controls the check; off by default.
ColumnLayout {
    spacing: 12
    Checkbox { text: qsTr("Unchecked") }
    Checkbox { text: qsTr("Checked"); checked: true }
}
