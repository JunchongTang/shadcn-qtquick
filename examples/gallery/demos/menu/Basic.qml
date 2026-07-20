import QtQuick
import Shadcn

Button {
    id: trigger
    text: "Open Menu"
    variant: Button.Outline
    trailingIconName: "chevron-down"
    onClicked: menu.popup(0, trigger.height + 4)

    Menu {
        id: menu
        MenuItem { text: "Profile"; shortcut: "⇧⌘P"; iconName: "user" }
        MenuItem { text: "Settings"; shortcut: "⌘,"; iconName: "settings" }
        MenuItem { text: "Keyboard shortcuts"; shortcut: "⌘K" }
        MenuSeparator {}
        MenuItem { text: "New Team"; iconName: "users" }
        MenuSeparator {}
        MenuItem { text: "Log out"; shortcut: "⇧⌘Q"; iconName: "log-out" }
    }
}
