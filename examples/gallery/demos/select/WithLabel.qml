import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 220
    spacing: 6
    Label { text: qsTr("Fruit") }
    Select {
        Layout.fillWidth: true
        model: [qsTr("Apple"), qsTr("Banana"), qsTr("Blueberry")]
    }
}
