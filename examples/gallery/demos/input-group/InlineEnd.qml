import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// align="inline-end": icon at the end of the input (e.g. password visibility).
ColumnLayout {
    width: 320
    spacing: 6

    Label { text: qsTr("Input"); Layout.fillWidth: true }

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput {
            placeholderText: qsTr("Enter password")
            echoMode: TextInput.Password
        }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            LucideIcon { name: "eye-off"; size: 14; color: Theme.mutedForeground }
        }
    }

    Text {
        Layout.fillWidth: true
        text: qsTr("Icon positioned at the end.")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
