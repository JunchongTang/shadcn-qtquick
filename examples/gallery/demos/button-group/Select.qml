import QtQuick
import Shadcn

// 官方 button-group-select:Select + Input 编为一组,再与「发送」图标按钮分组(gap-2)。
Row {
    spacing: 8

    ButtonGroup {
        Select {
            width: 64
            model: ["$", "€", "£"]
            currentIndex: 0
            font.family: Theme.fontMono
        }
        Input {
            width: 140
            placeholderText: "10.00"
        }
    }
    ButtonGroup {
        Button { variant: Button.Outline; size: Button.Icon; iconName: "arrow-right" }
    }
}
