import QtQuick
import Shadcn

// Groups:分组 + 图标 + 分隔线(相邻分组间自动分隔)(command-groups)。
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
            model: [
                { heading: "Suggestions", items: [
                    { text: "Calendar",     icon: "calendar" },
                    { text: "Search Emoji", icon: "smile" },
                    { text: "Calculator",   icon: "calculator" }
                ] },
                { heading: "Settings", items: [
                    { text: "Profile",  icon: "user",        shortcut: "⌘P" },
                    { text: "Billing",  icon: "credit-card", shortcut: "⌘B" },
                    { text: "Settings", icon: "settings",    shortcut: "⌘S" }
                ] }
            ]
            onTriggered: dlg.close()
        }
    }
}
