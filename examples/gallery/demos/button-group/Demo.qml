import QtQuick
import Shadcn

// 官方 button-group-demo:邮件工具栏。多个 ButtonGroup 之间留 gap-2(外层 Row spacing 8),
// 组内相邻按钮首尾相接。末组的「更多」图标按钮打开下拉菜单。
Row {
    spacing: 8

    ButtonGroup {
        Button { variant: Button.Outline; size: Button.Icon; iconName: "arrow-left" }
    }
    ButtonGroup {
        Button { variant: Button.Outline; text: qsTr("Archive") }
        Button { variant: Button.Outline; text: qsTr("Report") }
    }
    ButtonGroup {
        Button { variant: Button.Outline; text: qsTr("Snooze") }
        Button {
            id: moreBtn
            variant: Button.Outline
            size: Button.Icon
            iconName: "more-horizontal"
            onClicked: moreMenu.popup(0, moreBtn.height + 4)

            Menu {
                id: moreMenu
                MenuItem { text: qsTr("Mark as Read"); iconName: "mail-check" }
                MenuItem { text: qsTr("Archive"); iconName: "archive" }
                MenuSeparator {}
                MenuItem { text: qsTr("Snooze"); iconName: "clock" }
                MenuItem { text: qsTr("Add to Calendar"); iconName: "calendar-plus" }
                MenuItem { text: qsTr("Add to List"); iconName: "list-filter" }
                MenuSeparator {}
                MenuItem { text: qsTr("Trash"); iconName: "trash-2" }
            }
        }
    }
}
