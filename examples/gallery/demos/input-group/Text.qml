import QtQuick
import QtQuick.Layouts
import Shadcn

// Text addons (leading / trailing / both). Declaration order is arbitrary; positioned automatically by align.
ColumnLayout {
    width: 320
    spacing: 20

    // Leading $ / trailing USD
    InputGroup {
        Layout.fillWidth: true
        InputGroupAddon { InputGroupText { text: "$" } }
        InputGroupInput { placeholderText: "0.00" }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupText { text: qsTr("USD") }
        }
    }

    // Leading https:// / trailing .com
    InputGroup {
        Layout.fillWidth: true
        InputGroupAddon { InputGroupText { text: "https://" } }
        InputGroupInput { placeholderText: qsTr("example.com") }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupText { text: qsTr(".com") }
        }
    }

    // Trailing domain
    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: qsTr("Enter your username") }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupText { text: qsTr("@company.com") }
        }
    }

    // Textarea + bottom character count
    InputGroup {
        Layout.fillWidth: true
        InputGroupTextarea {
            implicitHeight: 72
            placeholderText: qsTr("Enter your message")
        }
        InputGroupAddon {
            align: InputGroupAddon.BlockEnd
            InputGroupText { text: qsTr("120 characters left") }
        }
    }
}
