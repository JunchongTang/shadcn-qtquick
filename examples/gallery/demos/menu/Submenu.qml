import QtQuick
import Shadcn

// 嵌套 Menu 即子菜单:子菜单触发项由 Menu.delegate 自动生成(样式化 MenuItem + 右侧 chevron),
// 触发项文字取自子菜单的 title;子菜单面板继承 popover 样式。
Button {
    id: trigger
    text: qsTr("Open")
    variant: Button.Outline
    trailingIconName: "chevron-down"
    onClicked: menu.popup(0, trigger.height + 4)

    Menu {
        id: menu

        MenuItem { text: qsTr("Team") }

        Menu {
            title: qsTr("Invite users")

            MenuItem { text: qsTr("Email") }
            MenuItem { text: qsTr("Message") }

            Menu {
                title: qsTr("More options")
                MenuItem { text: qsTr("Calendly") }
                MenuItem { text: qsTr("Slack") }
                MenuSeparator {}
                MenuItem { text: qsTr("Webhook") }
            }

            MenuSeparator {}
            MenuItem { text: qsTr("Advanced...") }
        }

        MenuItem { text: qsTr("New Team"); shortcut: "⌘+T" }
    }
}
