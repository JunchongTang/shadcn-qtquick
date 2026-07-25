import QtQuick
import Shadcn

// 官方 button-group-split:一个动作按钮 + 分隔线 + 一个图标按钮 = 拆分按钮。
// 同 Separator:spacing:0 手工组合 + 手动 groupPosition。
Row {
    spacing: 0

    Button {
        variant: Button.Secondary
        text: qsTr("Button")
        groupPosition: Button.GroupFirst
    }
    ButtonGroupSeparator { length: 28 }   // default 按钮高 28
    Button {
        variant: Button.Secondary
        size: Button.Icon
        iconName: "plus"
        groupPosition: Button.GroupLast
    }
}
