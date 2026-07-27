import QtQuick
import QtQuick.Layouts
import Shadcn

// Alignment: start (receiver, left) and end (sender, right).
ColumnLayout {
    width: 360
    spacing: Theme.space6

    Message {
        MessageAvatar { fallback: "R" }
        MessageContent { variant: MessageContent.Muted; text: qsTr("Aligned to the start of the conversation.") }
    }
    Message {
        align: Message.End
        MessageAvatar { fallback: "ME" }
        MessageContent { variant: MessageContent.Default; text: qsTr("Aligned to the end of the conversation.") }
    }
}
