import QtQuick
import Shadcn

Rectangle {
    color: Theme.background
    implicitWidth: 340
    implicitHeight: 300

    Button {
        id: trigger
        x: 24
        y: 24
        text: "Open Menu"
        variant: Button.Outline
        trailingIconName: "chevron-down"

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

    Component.onCompleted: menu.popup(0, trigger.height + 4)
}
