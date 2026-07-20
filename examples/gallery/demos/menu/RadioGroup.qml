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
        implicitWidth: 128           // w-32

        MenuLabel { text: "Panel Position" }
        // 同一 Menu 内的 MenuRadioItem 自动互斥(autoExclusive)
        MenuRadioItem { text: "Top" }
        MenuRadioItem { text: "Bottom"; checked: true }
        MenuRadioItem { text: "Right" }
    }
}
