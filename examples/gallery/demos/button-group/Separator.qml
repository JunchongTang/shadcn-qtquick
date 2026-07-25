import QtQuick
import Shadcn

// 官方 button-group-separator:secondary 等无边框按钮之间用 ButtonGroupSeparator 分隔。
// 分隔线会被 ButtonGroup 的 spacing:-1 吞掉,故用 spacing:0 的手工组合 + 手动 groupPosition。
Row {
    spacing: 0

    Button {
        variant: Button.Secondary
        size: Button.Sm
        text: qsTr("Copy")
        groupPosition: Button.GroupFirst
    }
    ButtonGroupSeparator { length: 24 }   // sm 按钮高 24
    Button {
        variant: Button.Secondary
        size: Button.Sm
        text: qsTr("Paste")
        groupPosition: Button.GroupLast
    }
}
