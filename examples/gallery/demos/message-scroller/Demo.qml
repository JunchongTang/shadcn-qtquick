import QtQuick
import QtQuick.Layouts
import Shadcn

// 聊天滚动容器:置于固定高度的卡片框内,加载后自动贴底;上滑后浮现「跳至最新」按钮。
Rectangle {
    implicitWidth: 380
    implicitHeight: 460
    radius: Theme.radiusXl
    color: Theme.card
    border.width: Theme.overlayRingWidth
    border.color: Theme.overlayRing
    clip: true

    MessageScroller {
        anchors.fill: parent
        contentPadding: Theme.space4

        Message {
            MessageAvatar { fallback: "R" }
            MessageContent { variant: MessageContent.Muted; text: "Morning! Did the nightly build pass?" }
        }
        Message {
            align: Message.End
            MessageAvatar { fallback: "ME" }
            MessageContent { variant: MessageContent.Default; text: "Checking now, one sec." }
        }
        Message {
            MessageAvatar { fallback: "R" }
            MessageContent { variant: MessageContent.Muted; text: "Cool. The dependency step was flaky yesterday." }
        }
        Message {
            align: Message.End
            MessageAvatar { fallback: "ME" }
            MessageContent { variant: MessageContent.Default; text: "Green across the board. Even the slow integration suite." }
        }
        Message {
            MessageAvatar { fallback: "R" }
            MessageContent { variant: MessageContent.Muted; text: "Nice. Let's tag a release then." }
        }
        Message {
            align: Message.End
            MessageAvatar { fallback: "ME" }
            MessageContent { variant: MessageContent.Default; text: "On it. Cutting v1.4.0."; footer: "Delivered" }
        }
        Message {
            MessageAvatar { fallback: "R" }
            MessageContent { variant: MessageContent.Muted; typing: true }
        }
    }
}
