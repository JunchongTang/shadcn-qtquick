import QtQuick
import Shadcn

// 内联命令面板(command-demo)—— max-w-sm rounded-lg border,分组 + 图标 + shortcut。
Command {
    width: 384                    // max-w-sm
    showBorder: true              // rounded-lg border
    model: [
        { heading: "Suggestions", items: [
            { text: "Calendar",     icon: "calendar" },
            { text: "Search Emoji", icon: "smile" },
            { text: "Calculator",   icon: "calculator", disabled: true }
        ] },
        { heading: "Settings", items: [
            { text: "Profile",  icon: "user",        shortcut: "⌘P" },
            { text: "Billing",  icon: "credit-card", shortcut: "⌘B" },
            { text: "Settings", icon: "settings",    shortcut: "⌘S" }
        ] }
    ]
}
