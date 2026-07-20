import QtQuick
import QtQuick.Layouts
import Shadcn

// 分组连发:BubbleGroup 收紧同源气泡间距(gap-2)。align 设在各 Bubble 上。
// 对标官方 bubble-group-demo。
ColumnLayout {
    width: 360
    spacing: 32

    Bubble {
        variant: Bubble.Muted
        BubbleContent { text: "Can you tell me what's the issue?" }
    }

    BubbleGroup {
        Bubble {
            align: Bubble.End
            BubbleContent { text: "You tell me!" }
        }
        Bubble {
            align: Bubble.End
            BubbleContent { text: "It worked yesterday. You broke it!" }
        }
        Bubble {
            align: Bubble.End
            BubbleContent { text: "Find the bug and fix it." }
            BubbleReactions {
                align: Bubble.Start
                Text { text: "👀"; font.pixelSize: Theme.textXs }
            }
        }
    }

    Bubble {
        variant: Bubble.Muted
        BubbleContent {
            text: "Want me to diff yesterday's you against today's you? It's a bit embarrassing."
        }
    }
}
