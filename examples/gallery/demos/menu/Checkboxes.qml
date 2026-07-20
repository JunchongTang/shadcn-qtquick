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
        implicitWidth: 160           // w-40

        MenuLabel { text: "Appearance" }
        MenuCheckboxItem { text: "Status Bar"; checked: true }
        MenuCheckboxItem { text: "Activity Bar"; enabled: false }
        MenuCheckboxItem { text: "Panel" }
    }
}
