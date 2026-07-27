import QtQuick
import QtQuick.Layouts
import Shadcn

// Header (sender name, always left-aligned) + Footer (status text, sides with align).
ColumnLayout {
    width: 360
    spacing: Theme.space8

    Message {
        MessageContent {
            header: qsTr("Olivia")
            variant: MessageContent.Muted
            text: qsTr("I already checked the logs.")
        }
    }
    Message {
        align: Message.End
        MessageContent {
            variant: MessageContent.Default
            text: qsTr("Send the report to the team. Ping @shadcn if you need help.")
            footer: "Read · Yesterday"
        }
    }
}
