import QtQuick
import QtQuick.Layouts
import Shadcn

// Small buttons inside an addon: icon button (icon-xs) and text button (secondary).
ColumnLayout {
    width: 320
    spacing: 20

    // Read-only link + copy icon button
    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { text: "https://x.com/shadcn"; readOnly: true }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupButton {
                kind: InputGroupButton.KindIconXs
                iconName: "copy"
            }
        }
    }

    // Leading https:// + favorite icon button
    InputGroup {
        Layout.fillWidth: true
        InputGroupAddon { InputGroupText { text: "https://" } }
        InputGroupInput { placeholderText: "" }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupButton {
                kind: InputGroupButton.KindIconXs
                iconName: "star"
            }
        }
    }

    // Search text button
    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: qsTr("Type to search...") }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupButton {
                kind: InputGroupButton.KindXs
                variant: Button.Secondary
                text: qsTr("Search")
            }
        }
    }
}
