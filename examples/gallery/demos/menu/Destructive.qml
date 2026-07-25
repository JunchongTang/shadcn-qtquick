import QtQuick
import Shadcn

Button {
    id: trigger
    text: qsTr("Actions")
    variant: Button.Outline
    trailingIconName: "chevron-down"
    onClicked: menu.popup(0, trigger.height + 4)

    Menu {
        id: menu

        MenuItem { text: qsTr("Edit"); iconName: "pencil" }
        MenuItem { text: qsTr("Share"); iconName: "share" }
        MenuSeparator {}
        MenuItem { text: qsTr("Delete"); iconName: "trash"; destructive: true }
    }
}
