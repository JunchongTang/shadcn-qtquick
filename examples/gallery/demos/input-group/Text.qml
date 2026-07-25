import QtQuick
import QtQuick.Layouts
import Shadcn

// 文本 addon(前缀 / 后缀 / 前后组合)。声明顺序任意,按 align 自动定位。
ColumnLayout {
    width: 320
    spacing: 20

    // 前 $ / 后 USD
    InputGroup {
        Layout.fillWidth: true
        InputGroupAddon { InputGroupText { text: "$" } }
        InputGroupInput { placeholderText: "0.00" }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupText { text: qsTr("USD") }
        }
    }

    // 前 https:// / 后 .com
    InputGroup {
        Layout.fillWidth: true
        InputGroupAddon { InputGroupText { text: "https://" } }
        InputGroupInput { placeholderText: qsTr("example.com") }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupText { text: qsTr(".com") }
        }
    }

    // 后缀域名
    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: qsTr("Enter your username") }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupText { text: qsTr("@company.com") }
        }
    }

    // 文本域 + 底部字数
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
