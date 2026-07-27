import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// align="block-start": addon sits above the input/textarea (vertical).
ColumnLayout {
    width: 340
    spacing: 20

    // Input + top title
    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: qsTr("Enter your name") }
        InputGroupAddon {
            align: InputGroupAddon.BlockStart
            InputGroupText { text: qsTr("Full Name") }
        }
    }

    // Textarea + top toolbar (icon + filename + copy)
    InputGroup {
        Layout.fillWidth: true
        InputGroupTextarea {
            implicitHeight: 96
            placeholderText: qsTr("console.log('Hello, world!');")
            font.family: Theme.fontMono
        }
        InputGroupAddon {
            align: InputGroupAddon.BlockStart
            border: true
            LucideIcon { name: "file-code"; size: 14; color: Theme.mutedForeground }
            InputGroupText {
                text: qsTr("script.js")
                font.family: Theme.fontMono
                Layout.fillWidth: true
            }
            InputGroupButton { kind: InputGroupButton.KindIconXs; iconName: "copy" }
        }
    }
}
