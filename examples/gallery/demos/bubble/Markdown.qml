import QtQuick
import QtQuick.Layouts
import Shadcn

// Markdown content: use Text.MarkdownText to approximate rich text (bold / inline code / paragraphs).
// Mirrors official bubble-markdown.
ColumnLayout {
    width: 360
    spacing: 32

    Bubble {
        variant: Bubble.Muted
        align: Bubble.End
        BubbleContent {
            id: mdBubble
            Text {
                Layout.maximumWidth: mdBubble._innerMaxW
                textFormat: Text.MarkdownText
                text: qsTr("Hello! Are you actually **thinking**?")
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                lineHeight: Theme.lineRelaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
            }
        }
    }

    Bubble {
        variant: Bubble.Ghost
        BubbleContent {
            id: ghostBubble
            Text {
                Layout.maximumWidth: ghostBubble._innerMaxW
                textFormat: Text.MarkdownText
                text: qsTr("Ghost bubbles work for assistant text, **markdown**, and other content ")
                      + "that should not be framed.\n\nThis is perfect for assistant messages that "
                      + "should not have a frame and can take the full width of the container. "
                      + "You can also render `code` in it.\n\n"
                      + "Ghost bubbles are full width and can take the full width of the container."
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                lineHeight: Theme.lineRelaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
            }
        }
    }
}
