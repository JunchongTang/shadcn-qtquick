import QtQuick
import QtQuick.Layouts
import Shadcn

// 长转录:12 条消息超出视口,可上下滚动;细滚动条 + 跳至最新按钮。
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
