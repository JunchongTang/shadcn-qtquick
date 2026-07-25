import QtQuick
import Shadcn

// Shortcuts:条目右侧对齐键盘提示(command-shortcuts)。
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
            model: [
                { heading: qsTr("Settings"), items: [
                    { text: qsTr("Profile"),  icon: "user",        shortcut: "⌘P" },
                    { text: qsTr("Billing"),  icon: "credit-card", shortcut: "⌘B" },
                    { text: qsTr("Settings"), icon: "settings",    shortcut: "⌘S" }
                ] }
            ]
            onTriggered: dlg.close()
        }
    }
}
