import QtQuick
import Shadcn

// Scrollable:大量分组条目,列表在 max-h-72 内滚动(command-scrollable)。
Button {
    text: "Open Menu"
    variant: Button.Outline
    onClicked: dlg.open()

    Dialog {
        id: dlg
        padding: 0
        showCloseButton: false
        implicitWidth: 420
        onOpened: cmd.focusInput()

        Command {
            id: cmd
            onTriggered: dlg.close()
            model: [
                { heading: "Navigation", items: [
                    { text: "Home",      icon: "home",      shortcut: "⌘H" },
                    { text: "Inbox",     icon: "inbox",     shortcut: "⌘I" },
                    { text: "Documents", icon: "file-text", shortcut: "⌘D" },
                    { text: "Folders",   icon: "folder",    shortcut: "⌘F" }
                ] },
                { heading: "Actions", items: [
                    { text: "New File",   icon: "plus",            shortcut: "⌘N" },
                    { text: "New Folder", icon: "folder-plus",     shortcut: "⇧⌘N" },
                    { text: "Copy",       icon: "copy",            shortcut: "⌘C" },
                    { text: "Cut",        icon: "scissors",        shortcut: "⌘X" },
                    { text: "Paste",      icon: "clipboard-paste", shortcut: "⌘V" },
                    { text: "Delete",     icon: "trash",           shortcut: "⌫" }
                ] },
                { heading: "View", items: [
                    { text: "Grid View", icon: "layout-grid" },
                    { text: "List View", icon: "list" },
                    { text: "Zoom In",   icon: "zoom-in",  shortcut: "⌘+" },
                    { text: "Zoom Out",  icon: "zoom-out", shortcut: "⌘-" }
                ] },
                { heading: "Account", items: [
                    { text: "Profile",       icon: "user",        shortcut: "⌘P" },
                    { text: "Billing",       icon: "credit-card", shortcut: "⌘B" },
                    { text: "Settings",      icon: "settings",    shortcut: "⌘S" },
                    { text: "Notifications", icon: "bell" },
                    { text: "Help & Support", icon: "circle-help" }
                ] },
                { heading: "Tools", items: [
                    { text: "Calculator",  icon: "calculator" },
                    { text: "Calendar",    icon: "calendar" },
                    { text: "Image Editor", icon: "image" },
                    { text: "Code Editor", icon: "code" }
                ] }
            ]
        }
    }
}
