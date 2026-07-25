import QtQuick
import QtQuick.Layouts
import Shadcn

Card {
    width: 300
    size: Card.Small
    CardHeader {
        CardTitle { text: qsTr("Notifications") }
        CardDescription { text: qsTr("You have 3 unread messages.") }
    }
    CardContent {
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Badge { text: qsTr("New") }
            Text {
                Layout.fillWidth: true
                text: qsTr("Your call has been confirmed.")
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                wrapMode: Text.Wrap
            }
        }
    }
}
