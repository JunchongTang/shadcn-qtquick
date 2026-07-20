import QtQuick
import Shadcn

Button {
    id: trigger
    text: "Open"
    variant: Button.Outline
    trailingIconName: "chevron-down"
    onClicked: menu.popup(0, trigger.height + 4)

    Menu {
        id: menu

        MenuItem { text: "Profile"; iconName: "user" }
        MenuItem { text: "Billing"; iconName: "credit-card" }
        MenuItem { text: "Settings"; iconName: "settings" }
        MenuSeparator {}
        MenuItem { text: "Log out"; iconName: "log-out"; destructive: true }
    }
}
