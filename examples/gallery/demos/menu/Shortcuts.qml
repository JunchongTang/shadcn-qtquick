import QtQuick
import Shadcn

Button {
    id: trigger
    text: qsTr("Open")
    variant: Button.Outline
    trailingIconName: "chevron-down"
    onClicked: menu.popup(0, trigger.height + 4)

    Menu {
        id: menu

        MenuLabel { text: qsTr("My Account") }
        MenuItem { text: qsTr("Profile"); shortcut: "⇧⌘P" }
        MenuItem { text: qsTr("Billing"); shortcut: "⌘B" }
        MenuItem { text: qsTr("Settings"); shortcut: "⌘S" }
        MenuSeparator {}
        MenuItem { text: qsTr("Log out"); shortcut: "⇧⌘Q" }
    }
}
