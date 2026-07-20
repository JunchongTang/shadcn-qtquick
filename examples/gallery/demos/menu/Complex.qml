import QtQuick
import Shadcn

// 组合示例:分组标签 + 图标 + 快捷键 + 复选 + 单选 + 多级子菜单 + 破坏性项。
// 子菜单触发项的图标经「嵌套 Menu 的 icon.name」传入(delegate 读取 subMenu.icon.name)。
Button {
    id: trigger
    text: "Complex Menu"
    variant: Button.Outline
    trailingIconName: "chevron-down"
    onClicked: menu.popup(0, trigger.height + 4)

    Menu {
        id: menu
        implicitWidth: 176           // w-44

        // ---- File ----
        MenuLabel { text: "File" }
        MenuItem { text: "New File"; iconName: "file"; shortcut: "⌘N" }
        MenuItem { text: "New Folder"; iconName: "folder"; shortcut: "⇧⌘N" }

        Menu {
            title: "Open Recent"
            icon.name: "folder-open"

            MenuLabel { text: "Recent Projects" }
            MenuItem { text: "Project Alpha"; iconName: "file-code" }
            MenuItem { text: "Project Beta"; iconName: "file-code" }

            Menu {
                title: "More Projects"
                icon.name: "more-horizontal"
                MenuItem { text: "Project Gamma"; iconName: "file-code" }
                MenuItem { text: "Project Delta"; iconName: "file-code" }
            }

            MenuSeparator {}
            MenuItem { text: "Browse..."; iconName: "folder-search" }
        }

        MenuSeparator {}
        MenuItem { text: "Save"; iconName: "save"; shortcut: "⌘S" }
        MenuItem { text: "Export"; iconName: "download"; shortcut: "⇧⌘E" }

        MenuSeparator {}

        // ---- View ----
        MenuLabel { text: "View" }
        MenuCheckboxItem { text: "Show Sidebar"; iconName: "eye"; checked: true }
        MenuCheckboxItem { text: "Show Status Bar"; iconName: "layout" }

        Menu {
            title: "Theme"
            icon.name: "palette"

            MenuLabel { text: "Appearance" }
            MenuRadioItem { text: "Light"; iconName: "sun"; checked: true }
            MenuRadioItem { text: "Dark"; iconName: "moon" }
            MenuRadioItem { text: "System"; iconName: "monitor" }
        }

        MenuSeparator {}

        // ---- Account ----
        MenuLabel { text: "Account" }
        MenuItem { text: "Profile"; iconName: "user"; shortcut: "⇧⌘P" }
        MenuItem { text: "Billing"; iconName: "credit-card" }

        Menu {
            title: "Settings"
            icon.name: "settings"

            MenuLabel { text: "Preferences" }
            MenuItem { text: "Keyboard Shortcuts"; iconName: "keyboard" }
            MenuItem { text: "Language"; iconName: "languages" }
        }

        MenuSeparator {}
        MenuItem { text: "Help & Support"; iconName: "circle-help" }
        MenuItem { text: "Documentation"; iconName: "file-text" }

        MenuSeparator {}
        MenuItem { text: "Sign Out"; iconName: "log-out"; shortcut: "⇧⌘Q"; destructive: true }
    }
}
