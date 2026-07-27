import QtQuick
import QtQuick.Layouts
import Shadcn

// Grouped bursts: BubbleGroup tightens spacing between same-source bubbles (gap-2). align is set on each Bubble.
// Mirrors official bubble-group-demo.
ColumnLayout {
    width: 360
    spacing: 32

    Bubble {
        variant: Bubble.Muted
        BubbleContent { text: qsTr("Can you tell me what's the issue?") }
    }

    BubbleGroup {
        Bubble {
            align: Bubble.End
            BubbleContent { text: qsTr("You tell me!") }
        }
        Bubble {
            align: Bubble.End
            BubbleContent { text: qsTr("It worked yesterday. You broke it!") }
        }
        Bubble {
            align: Bubble.End
            BubbleContent { text: qsTr("Find the bug and fix it.") }
            BubbleReactions {
                align: Bubble.Start
                Text { text: "👀"; font.pixelSize: Theme.textXs }
            }
        }
    }

    Bubble {
        variant: Bubble.Muted
        BubbleContent {
            text: qsTr("Want me to diff yesterday's you against today's you? It's a bit embarrassing.")
        }
    }
}
