import QtQuick
import QtQuick.Layouts
import Shadcn

// A conversation snippet: left/right alignment, bubble variants, Delivered status, trailing typing dot animation.
ColumnLayout {
    width: 360
    spacing: Theme.space6

    Message {
        align: Message.End
        MessageAvatar { fallback: "ME" }
        MessageContent { variant: MessageContent.Default; text: qsTr("Deploying to prod real quick.") }
    }
    Message {
        MessageAvatar { fallback: "R" }
        MessageContent { variant: MessageContent.Muted; text: qsTr("It's 4:55 PM. On a Friday.") }
    }
    Message {
        align: Message.End
        MessageAvatar { fallback: "ME" }
        MessageContent {
            variant: MessageContent.Default
            text: qsTr("It's a one-line change.")
            footer: "Delivered"
        }
    }
    Message {
        MessageAvatar { fallback: "R" }
        MessageContent {
            variant: MessageContent.Muted
            text: qsTr("It's always a one-line change. Alright, let me take a look.")
        }
    }
    Message {
        MessageAvatar { fallback: "O" }
        MessageContent { variant: MessageContent.Muted; typing: true }
    }
}
