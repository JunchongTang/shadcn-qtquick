import QtQuick
import Shadcn

RadioGroup {
    RadioButton { text: qsTr("Disabled"); enabled: false }
    RadioButton { text: qsTr("Option 2"); checked: true }
    RadioButton { text: qsTr("Option 3") }
}
