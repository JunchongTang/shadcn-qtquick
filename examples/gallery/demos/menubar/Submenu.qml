import QtQuick
import Shadcn

// 子菜单:嵌套 Menu 即子菜单(触发项由 Menu.delegate 自动生成,右侧 chevron)。
Menubar {
    id: menubar

    MenubarMenu {
        title: "File"

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
            MenuItem { text: "Find..." }
            MenuItem { text: "Find Next" }
            MenuItem { text: "Find Previous" }
        }
        MenuSeparator {}
        MenuItem { text: "Cut" }
        MenuItem { text: "Copy" }
        MenuItem { text: "Paste" }
    }
}
