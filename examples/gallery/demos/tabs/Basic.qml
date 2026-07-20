import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 400
    spacing: 12

    Tabs {
        id: tabs
        Layout.fillWidth: true
        TabButton { text: "Account" }
        TabButton { text: "Password" }
    }

    Card {
        Layout.fillWidth: true
        CardHeader {
            CardTitle { text: tabs.currentIndex === 0 ? "Account" : "Password" }
            CardDescription {
                text: tabs.currentIndex === 0
                      ? "Make changes to your account here."
                      : "Change your password here."
            }
        }
        CardContent {
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6
                Label { text: tabs.currentIndex === 0 ? "Name" : "Current password" }
                Input { Layout.fillWidth: true }
            }
        }
    }
}
