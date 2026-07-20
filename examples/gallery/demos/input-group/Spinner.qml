import QtQuick
import QtQuick.Layouts
import Shadcn

// 加载态:Spinner 作为 addon(前缀 / 后缀 / 与文本并列)。
ColumnLayout {
    width: 320
    spacing: 16

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: "Searching..." }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            Spinner { size: 14; color: Theme.mutedForeground }
        }
    }

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: "Processing..." }
        InputGroupAddon {
            Spinner { size: 14; color: Theme.mutedForeground }
        }
    }

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: "Saving changes..." }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupText { text: "Saving..." }
            Spinner { size: 14; color: Theme.mutedForeground }
        }
    }
}
