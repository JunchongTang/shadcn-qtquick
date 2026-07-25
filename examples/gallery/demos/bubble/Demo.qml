import QtQuick
import QtQuick.Layouts
import Shadcn

// 综合演示:左右对齐、分组连发、表情。对标官方 bubble-demo。
ColumnLayout {
    width: 360
    spacing: 32   // gap-8:为叠边表情预留竖向空间

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
