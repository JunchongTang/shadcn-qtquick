import QtQuick
import QtQuick.Layouts
import Shadcn

// align="block-end":addon 位于输入/文本域下方(纵向)。
ColumnLayout {
    width: 340
    spacing: 20

    // 输入 + 底部单位
    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: qsTr("Enter amount") }
        InputGroupAddon {
            align: InputGroupAddon.BlockEnd
            InputGroupText { text: qsTr("USD") }
        }
    }

    // 文本域 + 底部计数 + 提交按钮(靠右)
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
