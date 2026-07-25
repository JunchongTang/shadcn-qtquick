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
                { heading: qsTr("Suggestions"), items: [
                    { text: qsTr("Calendar"), iconName: "calendar" },
                    { text: qsTr("Search Emoji"), iconName: "smile" },
                    { text: qsTr("Calculator"), iconName: "calculator" }
                ] },
                { heading: qsTr("Settings"), items: [
                    { text: qsTr("Profile"), iconName: "user" },
                    { text: qsTr("Billing"), iconName: "credit-card" },
                    { text: qsTr("Settings"), iconName: "settings" }
                ] }
            ]
        }
    }

    Component.onCompleted: dlg.open()
}
