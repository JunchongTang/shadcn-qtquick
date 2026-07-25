import QtQuick
import Shadcn

// Groups:分组 + 图标 + 分隔线(相邻分组间自动分隔)(command-groups)。
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
                { heading: qsTr("Suggestions"), items: [
                    { text: qsTr("Calendar"),     icon: "calendar" },
                    { text: qsTr("Search Emoji"), icon: "smile" },
                    { text: qsTr("Calculator"),   icon: "calculator" }
                ] },
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
