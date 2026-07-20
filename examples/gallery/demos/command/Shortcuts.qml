import QtQuick
import Shadcn

// Shortcuts:条目右侧对齐键盘提示(command-shortcuts)。
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
