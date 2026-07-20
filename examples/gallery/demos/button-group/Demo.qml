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
        Button { variant: Button.Outline; text: "Archive" }
        Button { variant: Button.Outline; text: "Report" }
    }
    ButtonGroup {
        Button { variant: Button.Outline; text: "Snooze" }
        Button {
            id: moreBtn
            variant: Button.Outline
            size: Button.Icon
            iconName: "more-horizontal"
            onClicked: moreMenu.popup(0, moreBtn.height + 4)

            Menu {
                id: moreMenu
                MenuItem { text: "Mark as Read"; iconName: "mail-check" }
                MenuItem { text: "Archive"; iconName: "archive" }
                MenuSeparator {}
                MenuItem { text: "Snooze"; iconName: "clock" }
                MenuItem { text: "Add to Calendar"; iconName: "calendar-plus" }
                MenuItem { text: "Add to List"; iconName: "list-filter" }
                MenuSeparator {}
                MenuItem { text: "Trash"; iconName: "trash-2" }
            }
        }
    }
}
