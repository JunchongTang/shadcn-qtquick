import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// align="inline-start": icon at the start of the input (default). Includes Label + description.
ColumnLayout {
    width: 320
    spacing: 6

    Label { text: qsTr("Input"); Layout.fillWidth: true }

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: qsTr("Search...") }
        InputGroupAddon {
            align: InputGroupAddon.InlineStart
            LucideIcon { name: "search"; size: 14; color: Theme.mutedForeground }
        }
    }

    Text {
        Layout.fillWidth: true
        text: qsTr("Icon positioned at the start.")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
