import QtQuick
import QtQuick.Layouts
import Shadcn

// Alignment:start(接收方,左)与 end(发送方,右)。
ColumnLayout {
    width: 360
    spacing: Theme.space6

    Message {
        MessageAvatar { fallback: "R" }
        MessageContent { variant: MessageContent.Muted; text: "Aligned to the start of the conversation." }
    }
    Message {
        align: Message.End
        MessageAvatar { fallback: "ME" }
        MessageContent { variant: MessageContent.Default; text: "Aligned to the end of the conversation." }
    }
}
