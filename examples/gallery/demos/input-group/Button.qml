import QtQuick
import QtQuick.Layouts
import Shadcn

// addon 内的小按钮:图标按钮(icon-xs)与文本按钮(secondary)。
ColumnLayout {
    width: 320
    spacing: 20

    // 只读链接 + 复制图标按钮
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

    // 前缀 https:// + 收藏图标按钮
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

    // 搜索文本按钮
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
