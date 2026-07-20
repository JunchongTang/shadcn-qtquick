import QtQuick
import QtQuick.Layouts
import Shadcn

// 一段会话:左右对齐、气泡变体、Delivered 状态、末尾 typing 点动画。
ColumnLayout {
    width: 360
    spacing: Theme.space6

    Message {
        align: Message.End
        MessageAvatar { fallback: "ME" }
        MessageContent { variant: MessageContent.Default; text: "Deploying to prod real quick." }
    }
    Message {
        MessageAvatar { fallback: "R" }
        MessageContent { variant: MessageContent.Muted; text: "It's 4:55 PM. On a Friday." }
    }
    Message {
        align: Message.End
        MessageAvatar { fallback: "ME" }
        MessageContent {
            variant: MessageContent.Default
            text: "It's a one-line change."
            footer: "Delivered"
        }
    }
    Message {
        MessageAvatar { fallback: "R" }
        MessageContent {
            variant: MessageContent.Muted
            text: "It's always a one-line change. Alright, let me take a look."
        }
    }
    Message {
        MessageAvatar { fallback: "O" }
        MessageContent { variant: MessageContent.Muted; typing: true }
    }
}
