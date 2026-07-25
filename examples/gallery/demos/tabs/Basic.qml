import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 400
    spacing: 12

    Tabs {
        id: tabs
        Layout.fillWidth: true
        TabButton { text: qsTr("Account") }
        TabButton { text: qsTr("Password") }
    }

    Card {
        Layout.fillWidth: true
        CardHeader {
            CardTitle { text: tabs.currentIndex === 0 ? qsTr("Account") : qsTr("Password") }
            CardDescription {
                text: tabs.currentIndex === 0
                      ? qsTr("Make changes to your account here.")
                      : qsTr("Change your password here.")
            }
        }
        CardContent {
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6
                Label { text: tabs.currentIndex === 0 ? qsTr("Name") : qsTr("Current password") }
                Input { Layout.fillWidth: true }
            }
        }
    }
}
