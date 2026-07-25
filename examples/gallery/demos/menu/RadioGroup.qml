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
        implicitWidth: 128           // w-32

        MenuLabel { text: qsTr("Panel Position") }
        // 同一 Menu 内的 MenuRadioItem 自动互斥(autoExclusive)
        MenuRadioItem { text: qsTr("Top") }
        MenuRadioItem { text: qsTr("Bottom"); checked: true }
        MenuRadioItem { text: qsTr("Right") }
    }
}
