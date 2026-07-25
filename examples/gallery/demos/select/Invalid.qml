import QtQuick
import QtQuick.Layouts
import Shadcn

// 错误态:invalid:true → 破坏色边框 + 破坏色环,配合错误提示文字。
ColumnLayout {
    width: 200
    spacing: 6
    Label { text: qsTr("Fruit") }
    Select {
        Layout.fillWidth: true
        invalid: true
        textRole: "text"
        currentIndex: -1
        placeholder: qsTr("Select a fruit")
        model: [
            { text: qsTr("Apple") },
            { text: qsTr("Banana") },
            { text: qsTr("Blueberry") }
        ]
    }
    Text {
        text: qsTr("Please select a fruit.")
        color: Theme.destructive
        font.pixelSize: Theme.textXs
    }
}
