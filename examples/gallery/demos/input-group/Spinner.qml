import QtQuick
import QtQuick.Layouts
import Shadcn

// Loading state: Spinner as an addon (leading / trailing / alongside text).
ColumnLayout {
    width: 320
    spacing: 16

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: qsTr("Searching...") }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            Spinner { size: 14; color: Theme.mutedForeground }
        }
    }

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: qsTr("Processing...") }
        InputGroupAddon {
            Spinner { size: 14; color: Theme.mutedForeground }
        }
    }

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: qsTr("Saving changes...") }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupText { text: qsTr("Saving...") }
            Spinner { size: 14; color: Theme.mutedForeground }
        }
    }
}
