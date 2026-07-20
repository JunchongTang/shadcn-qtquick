import QtQuick
import Shadcn

// 复选项:可切换的选项,状态以尾随勾选呈现(复用 MenuCheckboxItem)。
Menubar {
    id: menubar

    MenubarMenu {
        title: "View"
        menuWidth: 256               // w-64

        MenuCheckboxItem { text: "Always Show Bookmarks Bar" }
        MenuCheckboxItem { text: "Always Show Full URLs"; checked: true }
        MenuSeparator {}
        MenuItem { text: "Reload"; shortcut: "⌘R" }
        MenuItem { text: "Force Reload"; shortcut: "⇧⌘R"; enabled: false }
    }

    MenubarMenu {
        title: "Format"

        MenuCheckboxItem { text: "Strikethrough"; checked: true }
        MenuCheckboxItem { text: "Code" }
        MenuCheckboxItem { text: "Superscript" }
    }
}
