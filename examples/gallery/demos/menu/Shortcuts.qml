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

        MenuLabel { text: "My Account" }
        MenuItem { text: "Profile"; shortcut: "⇧⌘P" }
        MenuItem { text: "Billing"; shortcut: "⌘B" }
        MenuItem { text: "Settings"; shortcut: "⌘S" }
        MenuSeparator {}
        MenuItem { text: "Log out"; shortcut: "⇧⌘Q" }
    }
}
