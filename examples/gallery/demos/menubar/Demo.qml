import QtQuick
import Shadcn

// 典型桌面应用菜单栏:File / Edit / View / Profiles —— 含分组、快捷键、子菜单、
// 复选、单选(复用 Menu 族)。点任一触发按钮打开对应菜单,展开时悬停切换。
Menubar {
    id: menubar

    MenubarMenu {
        title: "File"

        MenuItem { text: "New Tab"; shortcut: "⌘T" }
        MenuItem { text: "New Window"; shortcut: "⌘N" }
        MenuItem { text: "New Incognito Window"; enabled: false }
        MenuSeparator {}
        Menu {
            title: "Share"
            MenuItem { text: "Email link" }
            MenuItem { text: "Messages" }
            MenuItem { text: "Notes" }
        }
        MenuSeparator {}
        MenuItem { text: "Print..."; shortcut: "⌘P" }
    }

    MenubarMenu {
        title: "Edit"

        MenuItem { text: "Undo"; shortcut: "⌘Z" }
        MenuItem { text: "Redo"; shortcut: "⇧⌘Z" }
        MenuSeparator {}
        Menu {
            title: "Find"
            MenuItem { text: "Search the web" }
            MenuSeparator {}
            MenuItem { text: "Find..." }
            MenuItem { text: "Find Next" }
            MenuItem { text: "Find Previous" }
        }
        MenuSeparator {}
        MenuItem { text: "Cut" }
        MenuItem { text: "Copy" }
        MenuItem { text: "Paste" }
    }

    MenubarMenu {
        title: "View"
        menuWidth: 176               // w-44

        MenuCheckboxItem { text: "Bookmarks Bar" }
        MenuCheckboxItem { text: "Full URLs"; checked: true }
        MenuSeparator {}
        MenuItem { text: "Reload"; shortcut: "⌘R" }
        MenuItem { text: "Force Reload"; shortcut: "⇧⌘R"; enabled: false }
        MenuSeparator {}
        MenuItem { text: "Toggle Fullscreen" }
        MenuSeparator {}
        MenuItem { text: "Hide Sidebar" }
    }

    MenubarMenu {
        title: "Profiles"

        MenuRadioItem { text: "Andy" }
        MenuRadioItem { text: "Benoit"; checked: true }
        MenuRadioItem { text: "Luis" }
        MenuSeparator {}
        MenuItem { text: "Edit..." }
        MenuSeparator {}
        MenuItem { text: "Add Profile..." }
    }
}
