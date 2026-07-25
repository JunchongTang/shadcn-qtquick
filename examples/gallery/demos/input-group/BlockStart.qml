import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// align="block-start":addon 位于输入/文本域上方(纵向)。
ColumnLayout {
    width: 340
    spacing: 20

    // 输入 + 顶部标题
    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: qsTr("Enter your name") }
        InputGroupAddon {
            align: InputGroupAddon.BlockStart
            InputGroupText { text: qsTr("Full Name") }
        }
    }

    // 文本域 + 顶部工具条(图标 + 文件名 + 复制)
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
