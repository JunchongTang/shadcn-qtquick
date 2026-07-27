import QtQuick
import QtQuick.Layouts
import Shadcn

// Typing visual state: a "typing" message at the bottom of the transcript (dot animation).
// Note: the basic version only provides the typing dot animation; true streaming character-by-character follow (follow live edge) is not implemented.
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
            MessageContent { variant: MessageContent.Default; text: qsTr("Can you summarize the incident report?") }
        }
        Message {
            MessageAvatar { fallback: "AI" }
            MessageContent { variant: MessageContent.Muted; text: qsTr("Sure — pulling the timeline together now.") }
        }
        Message {
            MessageAvatar { fallback: "AI" }
            MessageContent { variant: MessageContent.Muted; typing: true }
        }
    }
}
