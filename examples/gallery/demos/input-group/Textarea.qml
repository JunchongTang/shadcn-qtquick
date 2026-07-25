import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// 文本域版:顶部工具条(block-start + border-b)+ 底部状态栏(block-end + border-t)。
InputGroup {
    width: 400

    InputGroupTextarea {
        implicitHeight: 180
        placeholderText: qsTr("console.log('Hello, world!');")
        font.family: Theme.fontMono
    }

    // 顶部:语言图标 + 文件名 + 刷新/复制
    InputGroupAddon {
        align: InputGroupAddon.BlockStart
        border: true
        LucideIcon { name: "braces"; size: 14; color: Theme.mutedForeground }
        InputGroupText {
            text: qsTr("script.js")
            font.family: Theme.fontMono
            Layout.fillWidth: true
        }
        InputGroupButton { kind: InputGroupButton.KindIconXs; iconName: "refresh-cw" }
        InputGroupButton { kind: InputGroupButton.KindIconXs; iconName: "copy" }
    }

    // 底部:光标位置 + 运行按钮(靠右)
    InputGroupAddon {
        align: InputGroupAddon.BlockEnd
        border: true
        InputGroupText { text: qsTr("Line 1, Column 1"); Layout.fillWidth: true }
        InputGroupButton {
            kind: InputGroupButton.KindSm
            variant: Button.Default
            text: qsTr("Run")
            trailingIconName: "corner-down-left"
        }
    }
}
