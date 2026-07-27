import QtQuick
import Shadcn

// Vertical Tabs: TabButtons stacked vertically, text left-aligned; active pill as usual.
Tabs {
    vertical: true
    TabButton { text: qsTr("Account") }
    TabButton { text: qsTr("Password") }
    TabButton { text: qsTr("Notifications") }
}
