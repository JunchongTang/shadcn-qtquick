import QtQuick
import Shadcn

Rectangle {
    color: Theme.background
    implicitWidth: 560
    implicitHeight: 420

    Dialog {
        id: dlg
        padding: 0
        showCloseButton: false
        implicitWidth: 420

        Command {
            id: cmd
            model: [
                { heading: "Suggestions", items: [
                    { text: "Calendar", iconName: "calendar" },
                    { text: "Search Emoji", iconName: "smile" },
                    { text: "Calculator", iconName: "calculator" }
                ] },
                { heading: "Settings", items: [
                    { text: "Profile", iconName: "user" },
                    { text: "Billing", iconName: "credit-card" },
                    { text: "Settings", iconName: "settings" }
                ] }
            ]
        }
    }

    Component.onCompleted: dlg.open()
}
