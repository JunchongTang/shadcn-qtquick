import QtQuick
import Shadcn

// Combined example: group labels + icons + shortcuts + checkboxes + radios + multi-level submenus + destructive items.
// The submenu trigger item's icon is passed via the "nested Menu's icon.name" (delegate reads subMenu.icon.name).
Button {
    id: trigger
    text: qsTr("Complex Menu")
    variant: Button.Outline
    trailingIconName: "chevron-down"
    onClicked: menu.popup(0, trigger.height + 4)

    Menu {
        id: menu
        implicitWidth: 176           // w-44

        // ---- File ----
        MenuLabel { text: qsTr("File") }
        MenuItem { text: qsTr("New File"); iconName: "file"; shortcut: "⌘N" }
        MenuItem { text: qsTr("New Folder"); iconName: "folder"; shortcut: "⇧⌘N" }

        Menu {
            title: qsTr("Open Recent")
            icon.name: "folder-open"

            MenuLabel { text: qsTr("Recent Projects") }
            MenuItem { text: qsTr("Project Alpha"); iconName: "file-code" }
            MenuItem { text: qsTr("Project Beta"); iconName: "file-code" }

            Menu {
                title: qsTr("More Projects")
                icon.name: "more-horizontal"
                MenuItem { text: qsTr("Project Gamma"); iconName: "file-code" }
                MenuItem { text: qsTr("Project Delta"); iconName: "file-code" }
            }

            MenuSeparator {}
            MenuItem { text: qsTr("Browse..."); iconName: "folder-search" }
        }

        MenuSeparator {}
        MenuItem { text: qsTr("Save"); iconName: "save"; shortcut: "⌘S" }
        MenuItem { text: qsTr("Export"); iconName: "download"; shortcut: "⇧⌘E" }

        MenuSeparator {}

        // ---- View ----
        MenuLabel { text: qsTr("View") }
        MenuCheckboxItem { text: qsTr("Show Sidebar"); iconName: "eye"; checked: true }
        MenuCheckboxItem { text: qsTr("Show Status Bar"); iconName: "layout" }

        Menu {
            title: qsTr("Theme")
            icon.name: "palette"

            MenuLabel { text: qsTr("Appearance") }
            MenuRadioItem { text: qsTr("Light"); iconName: "sun"; checked: true }
            MenuRadioItem { text: qsTr("Dark"); iconName: "moon" }
            MenuRadioItem { text: qsTr("System"); iconName: "monitor" }
        }

        MenuSeparator {}

        // ---- Account ----
        MenuLabel { text: qsTr("Account") }
        MenuItem { text: qsTr("Profile"); iconName: "user"; shortcut: "⇧⌘P" }
        MenuItem { text: qsTr("Billing"); iconName: "credit-card" }

        Menu {
            title: qsTr("Settings")
            icon.name: "settings"

            MenuLabel { text: qsTr("Preferences") }
            MenuItem { text: qsTr("Keyboard Shortcuts"); iconName: "keyboard" }
            MenuItem { text: qsTr("Language"); iconName: "languages" }
        }

        MenuSeparator {}
        MenuItem { text: qsTr("Help & Support"); iconName: "circle-help" }
        MenuItem { text: qsTr("Documentation"); iconName: "file-text" }

        MenuSeparator {}
        MenuItem { text: qsTr("Sign Out"); iconName: "log-out"; shortcut: "⇧⌘Q"; destructive: true }
    }
}
