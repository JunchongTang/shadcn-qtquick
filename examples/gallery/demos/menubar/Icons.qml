import QtQuick
import Shadcn

// Icon + label for quick scanning (reuses MenuItem.iconName; destructive variant).
Menubar {
    id: menubar

    MenubarMenu {
        title: qsTr("File")

        MenuItem { text: qsTr("New File"); iconName: "file"; shortcut: "⌘N" }
        MenuItem { text: qsTr("Open Folder"); iconName: "folder" }
        MenuSeparator {}
        MenuItem { text: qsTr("Save"); iconName: "save"; shortcut: "⌘S" }
    }

    MenubarMenu {
        title: qsTr("More")

        MenuItem { text: qsTr("Settings"); iconName: "settings" }
        MenuItem { text: qsTr("Help"); iconName: "circle-help" }
        MenuSeparator {}
        MenuItem { text: qsTr("Delete"); iconName: "trash-2"; destructive: true }
    }
}
