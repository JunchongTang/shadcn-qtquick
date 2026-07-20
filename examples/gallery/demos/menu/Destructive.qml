import QtQuick
import Shadcn

Button {
    id: trigger
    text: "Actions"
    variant: Button.Outline
    trailingIconName: "chevron-down"
    onClicked: menu.popup(0, trigger.height + 4)

    Menu {
        id: menu

        MenuItem { text: "Edit"; iconName: "pencil" }
        MenuItem { text: "Share"; iconName: "share" }
        MenuSeparator {}
        MenuItem { text: "Delete"; iconName: "trash"; destructive: true }
    }
}
