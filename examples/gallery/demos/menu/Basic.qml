import QtQuick
import Shadcn

Button {
    id: trigger
    text: qsTr("Open Menu")
    variant: Button.Outline
    trailingIconName: "chevron-down"
    onClicked: menu.popup(0, trigger.height + 4)

    Menu {
        id: menu
        MenuItem { text: qsTr("Profile"); shortcut: "⇧⌘P"; iconName: "user" }
        MenuItem { text: qsTr("Settings"); shortcut: "⌘,"; iconName: "settings" }
        MenuItem { text: qsTr("Keyboard shortcuts"); shortcut: "⌘K" }
        MenuSeparator {}
        MenuItem { text: qsTr("New Team"); iconName: "users" }
        MenuSeparator {}
        MenuItem { text: qsTr("Log out"); shortcut: "⇧⌘Q"; iconName: "log-out" }
    }
}
