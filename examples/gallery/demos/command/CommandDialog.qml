import QtQuick
import QtQuick.Layouts
import Shadcn

// Command Dialog:全局快捷键 ⌘K 打开/关闭命令面板(command-dialog)。
ColumnLayout {
    spacing: 12

    RowLayout {
        spacing: 6
        Text {
            text: qsTr("Press")
            color: Theme.mutedForeground
            font.pixelSize: Theme.textSm
        }
        Kbd { text: qsTr("⌘K") }
    }

    // 全局快捷键(⌘K / Ctrl+K)切换面板。
    Shortcut {
        sequences: ["Ctrl+K", "Meta+K"]
        onActivated: dlg.visible ? dlg.close() : dlg.open()
    }

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
        }
    }
}
