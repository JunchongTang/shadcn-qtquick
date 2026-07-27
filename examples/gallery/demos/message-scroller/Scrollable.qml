import QtQuick
import QtQuick.Layouts
import Shadcn

// Long transcript: 12 messages overflow the viewport, scrollable up and down; thin scrollbar + jump-to-latest button.
Rectangle {
    implicitWidth: 380
    implicitHeight: 460
    radius: Theme.radiusXl
    color: Theme.card
    border.width: Theme.overlayRingWidth
    border.color: Theme.overlayRing
    clip: true

    MessageScroller {
        id: scroller
        anchors.fill: parent
        contentPadding: Theme.space4

        Repeater {
            model: 12
            delegate: Message {
                required property int index
                Layout.fillWidth: true
                align: index % 2 === 0 ? Message.Start : Message.End
                MessageAvatar { fallback: index % 2 === 0 ? qsTr("R") : qsTr("ME") }
                MessageContent {
                    variant: index % 2 === 0 ? MessageContent.Muted : MessageContent.Default
                    text: index % 2 === 0
                          ? "Review scroll checkpoint " + (index + 1) + "."
                          : "Checkpoint " + (index + 1) + " is synced and looks good."
                }
            }
        }
    }
}
