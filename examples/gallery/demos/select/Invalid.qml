import QtQuick
import QtQuick.Layouts
import Shadcn

// Error state: invalid:true → destructive-colored border + ring, paired with error hint text.
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
