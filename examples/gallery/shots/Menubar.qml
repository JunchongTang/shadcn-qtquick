import QtQuick
import Shadcn

Rectangle {
    color: Theme.background
    implicitWidth: 520
    implicitHeight: 360

    Menubar {
        id: menubar
        x: 24
        y: 24

        MenubarMenu {
            id: fileMenu
            title: qsTr("File")
            MenuItem { text: qsTr("New Tab"); shortcut: "⌘T" }
            MenuItem { text: qsTr("New Window"); shortcut: "⌘N" }
            MenuItem { text: qsTr("New Incognito Window"); enabled: false }
            MenuSeparator {}
            MenuItem { text: qsTr("Print..."); shortcut: "⌘P" }
        }
        MenubarMenu {
            title: qsTr("Edit")
            MenuItem { text: qsTr("Undo"); shortcut: "⌘Z" }
            MenuItem { text: qsTr("Redo"); shortcut: "⇧⌘Z" }
        }
        MenubarMenu {
            title: qsTr("View")
            MenuCheckboxItem { text: qsTr("Bookmarks Bar") }
            MenuCheckboxItem { text: qsTr("Full URLs"); checked: true }
        }
        MenubarMenu {
            title: qsTr("Profiles")
            MenuRadioItem { text: qsTr("Andy") }
            MenuRadioItem { text: qsTr("Benoit"); checked: true }
        }
    }

    Component.onCompleted: fileMenu.openNow()
}
