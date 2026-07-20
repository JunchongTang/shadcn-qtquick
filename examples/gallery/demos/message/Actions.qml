import QtQuick
import QtQuick.Layouts
import Shadcn

// Actions:消息级操作按钮(复制/点赞/点踩、失败重试)放在 footer。
// 默认子项(IconButton)即为操作组。此处 actionsOnHover=false 让操作常显以便预览;
// 默认行为是仅在消息 hover 时淡显(见 MessageContent.actionsOnHover)。
ColumnLayout {
    width: 360
    spacing: Theme.space8

    Message {
        MessageContent {
            variant: MessageContent.Muted
            text: "The install failure is coming from the workspace package."
            actionsOnHover: false
            IconButton { iconName: "copy"; size: IconButton.Small; variant: IconButton.Ghost }
            IconButton { iconName: "thumbs-up"; size: IconButton.Small; variant: IconButton.Ghost }
            IconButton { iconName: "thumbs-down"; size: IconButton.Small; variant: IconButton.Ghost }
        }
    }
    Message {
        align: Message.End
        MessageContent {
            variant: MessageContent.Default
            text: "Okay drop me a link. Taking a look..."
            footer: "Failed to send"
            footerDestructive: true
            actionsOnHover: false
            IconButton { iconName: "refresh-ccw"; size: IconButton.Small; variant: IconButton.Ghost }
        }
    }
}
