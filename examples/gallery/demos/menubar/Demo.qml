import QtQuick
import Shadcn

// 典型桌面应用菜单栏:File / Edit / View / Profiles —— 含分组、快捷键、子菜单、
// 复选、单选(复用 Menu 族)。点任一触发按钮打开对应菜单,展开时悬停切换。
Menubar {
    id: menubar

    MenubarMenu {
        title: qsTr("File")

        MenuItem { text: qsTr("New Tab"); shortcut: "⌘T" }
        MenuItem { text: qsTr("New Window"); shortcut: "⌘N" }
        MenuItem { text: qsTr("New Incognito Window"); enabled: false }
        MenuSeparator {}
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
            MenuItem { text: qsTr("Search the web") }
            MenuSeparator {}
            MenuItem { text: qsTr("Find...") }
            MenuItem { text: qsTr("Find Next") }
            MenuItem { text: qsTr("Find Previous") }
        }
        MenuSeparator {}
        MenuItem { text: qsTr("Cut") }
        MenuItem { text: qsTr("Copy") }
        MenuItem { text: qsTr("Paste") }
    }

    MenubarMenu {
        title: qsTr("View")
        menuWidth: 176               // w-44

        MenuCheckboxItem { text: qsTr("Bookmarks Bar") }
        MenuCheckboxItem { text: qsTr("Full URLs"); checked: true }
        MenuSeparator {}
        MenuItem { text: qsTr("Reload"); shortcut: "⌘R" }
        MenuItem { text: qsTr("Force Reload"); shortcut: "⇧⌘R"; enabled: false }
        MenuSeparator {}
        MenuItem { text: qsTr("Toggle Fullscreen") }
        MenuSeparator {}
        MenuItem { text: qsTr("Hide Sidebar") }
    }

    MenubarMenu {
        title: qsTr("Profiles")

        MenuRadioItem { text: qsTr("Andy") }
        MenuRadioItem { text: qsTr("Benoit"); checked: true }
        MenuRadioItem { text: qsTr("Luis") }
        MenuSeparator {}
        MenuItem { text: qsTr("Edit...") }
        MenuSeparator {}
        MenuItem { text: qsTr("Add Profile...") }
    }
}
