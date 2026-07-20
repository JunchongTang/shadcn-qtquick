import QtQuick
import Shadcn

// 图标 + 标签,便于快速扫读(复用 MenuItem.iconName;destructive 变体)。
Menubar {
    id: menubar

    MenubarMenu {
        title: "File"

        MenuItem { text: "New File"; iconName: "file"; shortcut: "⌘N" }
        MenuItem { text: "Open Folder"; iconName: "folder" }
        MenuSeparator {}
        MenuItem { text: "Save"; iconName: "save"; shortcut: "⌘S" }
    }

    MenubarMenu {
        title: "More"

        MenuItem { text: "Settings"; iconName: "settings" }
        MenuItem { text: "Help"; iconName: "circle-help" }
        MenuSeparator {}
        MenuItem { text: "Delete"; iconName: "trash-2"; destructive: true }
    }
}
