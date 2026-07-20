import QtQuick
import QtQuick.Layouts
import Shadcn

// 起止对齐:start(默认,收件方)/ end(发件方)。对标官方 bubble-alignment。
ColumnLayout {
    width: 360
    spacing: 32

    Bubble {
        variant: Bubble.Muted
        BubbleContent {
            text: "This bubble is aligned to the start. This is the default alignment."
        }
    }
    Bubble {
        align: Bubble.End
        BubbleContent {
            text: "This bubble is aligned to the end. Use this for user messages."
        }
    }
}
