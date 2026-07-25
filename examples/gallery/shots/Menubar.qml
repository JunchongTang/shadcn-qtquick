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
            title: "File"
            MenuItem { text: "New Tab"; shortcut: "⌘T" }
            MenuItem { text: "New Window"; shortcut: "⌘N" }
            MenuItem { text: "New Incognito Window"; enabled: false }
            MenuSeparator {}
            MenuItem { text: "Print..."; shortcut: "⌘P" }
        }
        MenubarMenu {
            title: "Edit"
            MenuItem { text: "Undo"; shortcut: "⌘Z" }
            MenuItem { text: "Redo"; shortcut: "⇧⌘Z" }
        }
        MenubarMenu {
            title: "View"
            MenuCheckboxItem { text: "Bookmarks Bar" }
            MenuCheckboxItem { text: "Full URLs"; checked: true }
        }
        MenubarMenu {
            title: "Profiles"
            MenuRadioItem { text: "Andy" }
            MenuRadioItem { text: "Benoit"; checked: true }
        }
    }

    Component.onCompleted: fileMenu.openNow()
}
