import QtQuick
import Shadcn

// 复选项:可切换的选项,状态以尾随勾选呈现(复用 MenuCheckboxItem)。
Menubar {
    id: menubar

    MenubarMenu {
        title: qsTr("View")
        menuWidth: 256               // w-64

        MenuCheckboxItem { text: qsTr("Always Show Bookmarks Bar") }
        MenuCheckboxItem { text: qsTr("Always Show Full URLs"); checked: true }
        MenuSeparator {}
        MenuItem { text: qsTr("Reload"); shortcut: "⌘R" }
        MenuItem { text: qsTr("Force Reload"); shortcut: "⇧⌘R"; enabled: false }
    }

    MenubarMenu {
        title: qsTr("Format")

        MenuCheckboxItem { text: qsTr("Strikethrough"); checked: true }
        MenuCheckboxItem { text: qsTr("Code") }
        MenuCheckboxItem { text: qsTr("Superscript") }
    }
}
