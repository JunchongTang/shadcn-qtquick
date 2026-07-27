import QtQuick
import QtQuick.Layouts
import Shadcn

// Attachment: image cover (above the bubble) and file card (below the bubble).
// Basic version: attachments are drawn inline via convenience properties (imageSource / fileName + fileMeta), not a full Attachment component.
// Images come from the network; a muted placeholder block is shown when offline.
ColumnLayout {
    width: 360
    spacing: Theme.space8

    Message {
        align: Message.End
        MessageContent {
            variant: MessageContent.Default
            imageSource: "https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=900&auto=format&fit=crop&q=80"
            text: qsTr("Here's the image. Can you add it to the PDF? Use it for the cover page.")
        }
    }
    Message {
        MessageContent {
            variant: MessageContent.Muted
            text: qsTr("Done. Here's the PDF with the image added as the cover page.")
            fileName: "sales-dashboard.pdf"
            fileMeta: "PDF · 2.4 MB"
        }
    }
    Message {
        align: Message.End
        MessageContent { variant: MessageContent.Default; text: qsTr("Thanks. Looks good.") }
    }
}
