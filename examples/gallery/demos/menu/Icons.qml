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

        MenuItem { text: qsTr("Profile"); iconName: "user" }
        MenuItem { text: qsTr("Billing"); iconName: "credit-card" }
        MenuItem { text: qsTr("Settings"); iconName: "settings" }
        MenuSeparator {}
        MenuItem { text: qsTr("Log out"); iconName: "log-out"; destructive: true }
    }
}
