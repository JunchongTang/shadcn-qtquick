import QtQuick
import Shadcn

// Scrollable: many grouped items, list scrolls within max-h-72 (command-scrollable).
Button {
    text: qsTr("Open Menu")
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
                { heading: qsTr("Navigation"), items: [
                    { text: qsTr("Home"),      icon: "home",      shortcut: "⌘H" },
                    { text: qsTr("Inbox"),     icon: "inbox",     shortcut: "⌘I" },
                    { text: qsTr("Documents"), icon: "file-text", shortcut: "⌘D" },
                    { text: qsTr("Folders"),   icon: "folder",    shortcut: "⌘F" }
                ] },
                { heading: qsTr("Actions"), items: [
                    { text: qsTr("New File"),   icon: "plus",            shortcut: "⌘N" },
                    { text: qsTr("New Folder"), icon: "folder-plus",     shortcut: "⇧⌘N" },
                    { text: qsTr("Copy"),       icon: "copy",            shortcut: "⌘C" },
                    { text: qsTr("Cut"),        icon: "scissors",        shortcut: "⌘X" },
                    { text: qsTr("Paste"),      icon: "clipboard-paste", shortcut: "⌘V" },
                    { text: qsTr("Delete"),     icon: "trash",           shortcut: "⌫" }
                ] },
                { heading: qsTr("View"), items: [
                    { text: qsTr("Grid View"), icon: "layout-grid" },
                    { text: qsTr("List View"), icon: "list" },
                    { text: qsTr("Zoom In"),   icon: "zoom-in",  shortcut: "⌘+" },
                    { text: qsTr("Zoom Out"),  icon: "zoom-out", shortcut: "⌘-" }
                ] },
                { heading: qsTr("Account"), items: [
                    { text: qsTr("Profile"),       icon: "user",        shortcut: "⌘P" },
                    { text: qsTr("Billing"),       icon: "credit-card", shortcut: "⌘B" },
                    { text: qsTr("Settings"),      icon: "settings",    shortcut: "⌘S" },
                    { text: qsTr("Notifications"), icon: "bell" },
                    { text: qsTr("Help & Support"), icon: "circle-help" }
                ] },
                { heading: qsTr("Tools"), items: [
                    { text: qsTr("Calculator"),  icon: "calculator" },
                    { text: qsTr("Calendar"),    icon: "calendar" },
                    { text: qsTr("Image Editor"), icon: "image" },
                    { text: qsTr("Code Editor"), icon: "code" }
                ] }
            ]
        }
    }
}
