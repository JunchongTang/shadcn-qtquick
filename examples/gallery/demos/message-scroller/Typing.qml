import QtQuick
import QtQuick.Layouts
import Shadcn

// Typing 视觉状态:转录底部一条「正在输入」消息(点动画)。
// 注:基础版仅提供 typing 点动画;真正的流式逐字跟随(follow live edge)未实现。
Rectangle {
    implicitWidth: 380
    implicitHeight: 360
    radius: Theme.radiusXl
    color: Theme.card
    border.width: Theme.overlayRingWidth
    border.color: Theme.overlayRing
    clip: true

    MessageScroller {
        anchors.fill: parent
        contentPadding: Theme.space4

        Message {
            align: Message.End
            MessageAvatar { fallback: "ME" }
            MessageContent { variant: MessageContent.Default; text: "Can you summarize the incident report?" }
        }
        Message {
            MessageAvatar { fallback: "AI" }
            MessageContent { variant: MessageContent.Muted; text: "Sure — pulling the timeline together now." }
        }
        Message {
            MessageAvatar { fallback: "AI" }
            MessageContent { variant: MessageContent.Muted; typing: true }
        }
    }
}
