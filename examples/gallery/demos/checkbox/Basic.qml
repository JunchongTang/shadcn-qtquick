import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    spacing: 10
    Checkbox { text: qsTr("Accept terms and conditions"); checked: true }
    Checkbox { text: qsTr("Enable notifications") }
    Checkbox { text: qsTr("Disabled"); enabled: false }
    Checkbox { text: qsTr("Disabled checked"); checked: true; enabled: false }
}
