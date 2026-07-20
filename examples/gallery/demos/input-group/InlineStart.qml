import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// align="inline-start":图标位于输入起始处(默认)。含 Label + 描述。
ColumnLayout {
    width: 320
    spacing: 6

    Label { text: "Input"; Layout.fillWidth: true }

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: "Search..." }
        InputGroupAddon {
            align: InputGroupAddon.InlineStart
            LucideIcon { name: "search"; size: 14; color: Theme.mutedForeground }
        }
    }

    Text {
        Layout.fillWidth: true
        text: "Icon positioned at the start."
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
