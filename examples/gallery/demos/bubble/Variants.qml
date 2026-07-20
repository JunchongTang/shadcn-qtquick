import QtQuick
import QtQuick.Layouts
import Shadcn

// 七种变体:default / secondary / muted / tinted / outline / destructive / ghost。
// 对标官方 bubble-variants(ghost 用富文本近似 markdown)。
ColumnLayout {
    width: 360
    spacing: 48   // gap-12:表情叠边预留

    Bubble {
        BubbleContent { text: "This is the default primary bubble." }
    }
    Bubble {
        variant: Bubble.Secondary
        align: Bubble.End
        BubbleContent { text: "This is the secondary variant." }
    }
    Bubble {
        variant: Bubble.Muted
        BubbleContent {
            text: "This one is muted. It uses a lower emphasis color for the chat bubble."
        }
        BubbleReactions {
            Text { text: "👍"; font.pixelSize: Theme.textXs }
        }
    }
    Bubble {
        variant: Bubble.Tinted
        align: Bubble.End
        BubbleContent {
            text: "This one is tinted. The tint is a softer color derived from the primary color."
        }
    }
    Bubble {
        variant: Bubble.Outline
        BubbleContent { text: "We can also use an outlined variant." }
    }
    Bubble {
        variant: Bubble.Destructive
        align: Bubble.End
        BubbleContent { text: "Or a destructive variant with a reaction." }
        BubbleReactions {
            Text { text: "🔥"; font.pixelSize: Theme.textXs }
        }
    }
    Bubble {
        variant: Bubble.Ghost
        BubbleContent {
            id: ghostContent
            Text {
                Layout.maximumWidth: ghostContent._innerMaxW
                textFormat: Text.MarkdownText
                text: "Ghost bubbles work for assistant text, **markdown**, and other content "
                      + "that should not be framed.\n\nThis is perfect for assistant messages that "
                      + "should not have a frame and can take the full width of the container. "
                      + "You can also render `code` in it."
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                lineHeight: Theme.lineRelaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
            }
        }
    }
}
