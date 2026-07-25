import QtQuick
import Shadcn

RadioGroup {
    RadioButton { text: qsTr("Default") }
    RadioButton { text: qsTr("Comfortable"); checked: true }
    RadioButton { text: qsTr("Compact") }
}
