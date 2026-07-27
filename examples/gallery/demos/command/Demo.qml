import QtQuick
import Shadcn

// Inline command palette (command-demo) — max-w-sm rounded-lg border, groups + icons + shortcut.
Command {
    width: 384                    // max-w-sm
    showBorder: true              // rounded-lg border
    model: [
        { heading: qsTr("Suggestions"), items: [
            { text: qsTr("Calendar"),     icon: "calendar" },
            { text: qsTr("Search Emoji"), icon: "smile" },
            { text: qsTr("Calculator"),   icon: "calculator", disabled: true }
        ] },
        { heading: qsTr("Settings"), items: [
            { text: qsTr("Profile"),  icon: "user",        shortcut: "⌘P" },
            { text: qsTr("Billing"),  icon: "credit-card", shortcut: "⌘B" },
            { text: qsTr("Settings"), icon: "settings",    shortcut: "⌘S" }
        ] }
    ]
}
