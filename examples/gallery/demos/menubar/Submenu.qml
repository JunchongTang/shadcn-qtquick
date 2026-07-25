import QtQuick
import Shadcn

// 子菜单:嵌套 Menu 即子菜单(触发项由 Menu.delegate 自动生成,右侧 chevron)。
Menubar {
    id: menubar

    MenubarMenu {
        title: qsTr("File")

        Menu {
            title: qsTr("Share")
            MenuItem { text: qsTr("Email link") }
            MenuItem { text: qsTr("Messages") }
            MenuItem { text: qsTr("Notes") }
        }
        MenuSeparator {}
        MenuItem { text: qsTr("Print..."); shortcut: "⌘P" }
    }

    MenubarMenu {
        title: qsTr("Edit")

        MenuItem { text: qsTr("Undo"); shortcut: "⌘Z" }
        MenuItem { text: qsTr("Redo"); shortcut: "⇧⌘Z" }
        MenuSeparator {}
        Menu {
            title: qsTr("Find")
            MenuItem { text: qsTr("Find...") }
            MenuItem { text: qsTr("Find Next") }
            MenuItem { text: qsTr("Find Previous") }
        }
        MenuSeparator {}
        MenuItem { text: qsTr("Cut") }
        MenuItem { text: qsTr("Copy") }
        MenuItem { text: qsTr("Paste") }
    }
}
