import QtQuick
import QtQuick.Layouts
import Shadcn

// Combined demo: left/right alignment, grouped bursts, reactions. Mirrors official bubble-demo.
ColumnLayout {
    width: 360
    spacing: 32   // gap-8: reserve vertical space for edge-overlapping reactions

    Bubble {
        align: Bubble.End
        BubbleContent { text: qsTr("Hey there! what's up?") }
    }

    BubbleGroup {
        Bubble {
            variant: Bubble.Muted
            BubbleContent { text: qsTr("Hey! Want to see chat bubbles?") }
        }
        Bubble {
            variant: Bubble.Muted
            BubbleContent {
                text: qsTr("I can group messages, switch sides, and keep the whole thread easy to scan.")
            }
            BubbleReactions {
                Text { text: "👍"; font.pixelSize: Theme.textXs }
            }
        }
    }

    Bubble {
        align: Bubble.End
        BubbleContent { text: qsTr("Sure. Hit me with your best demo.") }
    }

    Bubble {
        variant: Bubble.Muted
        BubbleContent {
            text: qsTr("Yes. You are reading a demo that is demoing itself. Very meta. Very on-brand.")
        }
        BubbleReactions {
            Text { text: "👍"; font.pixelSize: Theme.textXs }
            Text { text: "🔥"; font.pixelSize: Theme.textXs }
            Text { text: "👀"; font.pixelSize: Theme.textXs }
            Text { text: "+2"; font.pixelSize: Theme.textXs; color: Theme.mutedForeground }
        }
    }
}
