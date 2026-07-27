import QtQuick
import Shadcn

// Radio group: mutually exclusive options within a menu (reuses MenuRadioItem, autoExclusive within the same Menu).
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
