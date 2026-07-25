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
        implicitWidth: 160           // w-40

        MenuLabel { text: qsTr("Appearance") }
        MenuCheckboxItem { text: qsTr("Status Bar"); checked: true }
        MenuCheckboxItem { text: qsTr("Activity Bar"); enabled: false }
        MenuCheckboxItem { text: qsTr("Panel") }
    }
}
