import QtQuick
import QtQuick.Layouts
import Shadcn

// Link/button bubble: BubbleContent interactive: true (mirrors render={<button/>}).
// Clicking updates the status text at the bottom (replaces the official toast, keeps it self-contained). Mirrors bubble-link-button.
ColumnLayout {
    id: root
    width: 360
    spacing: 32

    property string status: ""

    Bubble {
        variant: Bubble.Muted
        BubbleContent { text: qsTr("How can I help you today?") }
    }

    BubbleGroup {
        Bubble {
            variant: Bubble.Tinted
            align: Bubble.End
            BubbleContent {
                text: qsTr("I forgot my password")
                interactive: true
                onClicked: root.status = "You clicked forgot password"
            }
        }
        Bubble {
            variant: Bubble.Tinted
            align: Bubble.End
            BubbleContent {
                text: qsTr("I need help with my subscription")
                interactive: true
                onClicked: root.status = "You clicked help with subscription"
            }
        }
        Bubble {
            variant: Bubble.Tinted
            align: Bubble.End
            BubbleContent {
                text: qsTr("Something else. Talk to a human.")
                interactive: true
                onClicked: root.status = "You clicked something else. Talk to a human."
            }
        }
    }

    Text {
        Layout.fillWidth: true
        visible: root.status !== ""
        text: root.status
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        horizontalAlignment: Text.AlignRight
    }
}
