import QtQuick
import QtQuick.Layouts
import Shadcn

// Chat scroll container: placed inside a fixed-height card frame, auto scroll-to-bottom after load; a "jump to latest" button appears once scrolled up.
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
            MessageContent { variant: MessageContent.Muted; text: qsTr("Morning! Did the nightly build pass?") }
        }
        Message {
            align: Message.End
            MessageAvatar { fallback: "ME" }
            MessageContent { variant: MessageContent.Default; text: qsTr("Checking now, one sec.") }
        }
        Message {
            MessageAvatar { fallback: "R" }
            MessageContent { variant: MessageContent.Muted; text: qsTr("Cool. The dependency step was flaky yesterday.") }
        }
        Message {
            align: Message.End
            MessageAvatar { fallback: "ME" }
            MessageContent { variant: MessageContent.Default; text: qsTr("Green across the board. Even the slow integration suite.") }
        }
        Message {
            MessageAvatar { fallback: "R" }
            MessageContent { variant: MessageContent.Muted; text: qsTr("Nice. Let's tag a release then.") }
        }
        Message {
            align: Message.End
            MessageAvatar { fallback: "ME" }
            MessageContent { variant: MessageContent.Default; text: qsTr("On it. Cutting v1.4.0."); footer: "Delivered" }
        }
        Message {
            MessageAvatar { fallback: "R" }
            MessageContent { variant: MessageContent.Muted; typing: true }
        }
    }
}
