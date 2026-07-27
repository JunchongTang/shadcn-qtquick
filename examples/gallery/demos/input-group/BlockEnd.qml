import QtQuick
import QtQuick.Layouts
import Shadcn

// align="block-end": addon sits below the input/textarea (vertical).
ColumnLayout {
    width: 340
    spacing: 20

    // Input + bottom unit
    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: qsTr("Enter amount") }
        InputGroupAddon {
            align: InputGroupAddon.BlockEnd
            InputGroupText { text: qsTr("USD") }
        }
    }

    // Textarea + bottom count + submit button (right-aligned)
    InputGroup {
        Layout.fillWidth: true
        InputGroupTextarea {
            implicitHeight: 88
            placeholderText: qsTr("Write a comment...")
        }
        InputGroupAddon {
            align: InputGroupAddon.BlockEnd
            InputGroupText { text: "0/280"; Layout.fillWidth: true }
            InputGroupButton {
                kind: InputGroupButton.KindSm
                variant: Button.Default
                text: qsTr("Post")
            }
        }
    }
}
