import QtQuick
import Shadcn

// 单选组:菜单内互斥选项(复用 MenuRadioItem,同一 Menu 内 autoExclusive 互斥)。
Menubar {
    id: menubar

    MenubarMenu {
        title: "Profiles"

        MenuRadioItem { text: "Andy" }
        MenuRadioItem { text: "Benoit"; checked: true }
        MenuRadioItem { text: "Luis" }
        MenuSeparator {}
        MenuItem { text: "Edit..." }
        MenuItem { text: "Add Profile..." }
    }

    MenubarMenu {
        title: "Theme"

        MenuRadioItem { text: "Light" }
        MenuRadioItem { text: "Dark" }
        MenuRadioItem { text: "System"; checked: true }
    }
}
