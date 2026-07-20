import QtQuick
import QtQuick.Layouts
import Shadcn

// 头像槽:align=start 头像在左,align=end 头像在右。
ColumnLayout {
    width: 360
    spacing: Theme.space6

    Message {
        MessageAvatar { fallback: "R" }
        MessageContent {
            variant: MessageContent.Muted
            text: "The build failed during dependency installation."
        }
    }
    Message {
        align: Message.End
        MessageAvatar { fallback: "ME" }
        MessageContent {
            variant: MessageContent.Default
            text: "Can you share the exact error?"
        }
    }
    Message {
        MessageAvatar { fallback: "R" }
        MessageContent {
            variant: MessageContent.Muted
            text: "Something went wrong with the build. The libraries are not installed correctly. Try running the build again."
        }
    }
}
