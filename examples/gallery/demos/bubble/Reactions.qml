import QtQuick
import QtQuick.Layouts
import Shadcn

// 表情行:side(top/bottom)+ align(start/end)定位;可放表情或按钮(padded:false)。
// 对标官方 bubble-reactions。
ColumnLayout {
    id: root
    width: 360
    spacing: 48   // gap-12:表情叠边预留

    property string status: ""

    Bubble {
        variant: Bubble.Muted
        align: Bubble.End
        BubbleContent { text: "I don't need tests, I know my code works." }
        BubbleReactions {
            align: Bubble.Start
            Text { text: "👍"; font.pixelSize: Theme.textXs }
            Text { text: "😮"; font.pixelSize: Theme.textXs }
        }
    }

    Bubble {
        variant: Bubble.Muted
        BubbleContent {
            text: "Bold. Fine I'll add some tests. I'll let you know when they're done."
        }
        BubbleReactions {
            Text { text: "👀"; font.pixelSize: Theme.textXs }
            Text { text: "🚀"; font.pixelSize: Theme.textXs }
            Text { text: "+2"; font.pixelSize: Theme.textXs; color: Theme.mutedForeground }
        }
    }

    Bubble {
        variant: Bubble.Default
        align: Bubble.End
        BubbleContent { text: "Tests passed on the first try. All 142 of them. Looking good!" }
        BubbleReactions {
            side: BubbleReactions.Top
            align: Bubble.Start
            Text { text: "🎉"; font.pixelSize: Theme.textXs }
            Text { text: "👏"; font.pixelSize: Theme.textXs }
        }
    }

    Bubble {
        variant: Bubble.Destructive
        BubbleContent { text: "Are you sure I can run this command?" }
        BubbleReactions {
            padded: false
            Button {
                variant: Button.Ghost
                size: Button.Xs
                text: "Yes, run it"
                onClicked: root.status = "You clicked yes, running command..."
            }
        }
    }

    Text {
        Layout.fillWidth: true
        visible: root.status !== ""
        text: root.status
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
    }
}
