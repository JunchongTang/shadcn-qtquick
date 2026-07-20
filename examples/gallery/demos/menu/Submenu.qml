import QtQuick
import Shadcn

// 嵌套 Menu 即子菜单:子菜单触发项由 Menu.delegate 自动生成(样式化 MenuItem + 右侧 chevron),
// 触发项文字取自子菜单的 title;子菜单面板继承 popover 样式。
Button {
    id: trigger
    text: "Open"
    variant: Button.Outline
    trailingIconName: "chevron-down"
    onClicked: menu.popup(0, trigger.height + 4)

    Menu {
        id: menu

        MenuItem { text: "Team" }

        Menu {
            title: "Invite users"

            MenuItem { text: "Email" }
            MenuItem { text: "Message" }

            Menu {
                title: "More options"
                MenuItem { text: "Calendly" }
                MenuItem { text: "Slack" }
                MenuSeparator {}
                MenuItem { text: "Webhook" }
            }

            MenuSeparator {}
            MenuItem { text: "Advanced..." }
        }

        MenuItem { text: "New Team"; shortcut: "⌘+T" }
    }
}
