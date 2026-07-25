import QtQuick
import Shadcn

// 单选组:菜单内互斥选项(复用 MenuRadioItem,同一 Menu 内 autoExclusive 互斥)。
Menubar {
    id: menubar

    MenubarMenu {
        title: qsTr("Profiles")

        MenuRadioItem { text: qsTr("Andy") }
        MenuRadioItem { text: qsTr("Benoit"); checked: true }
        MenuRadioItem { text: qsTr("Luis") }
        MenuSeparator {}
        MenuItem { text: qsTr("Edit...") }
        MenuItem { text: qsTr("Add Profile...") }
    }

    MenubarMenu {
        title: qsTr("Theme")

        MenuRadioItem { text: qsTr("Light") }
        MenuRadioItem { text: qsTr("Dark") }
        MenuRadioItem { text: qsTr("System"); checked: true }
    }
}
