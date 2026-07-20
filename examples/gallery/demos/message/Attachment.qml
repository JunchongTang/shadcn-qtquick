import QtQuick
import QtQuick.Layouts
import Shadcn

// Attachment:图片封面(气泡上方)与文件卡(气泡下方)。
// 基础版:附件为便捷属性内建绘制(imageSource / fileName + fileMeta),非完整 Attachment 组件。
// 图片来自网络,离线时显示 muted 占位块。
ColumnLayout {
    width: 360
    spacing: Theme.space8

    Message {
        align: Message.End
        MessageContent {
            variant: MessageContent.Default
            imageSource: "https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=900&auto=format&fit=crop&q=80"
            text: "Here's the image. Can you add it to the PDF? Use it for the cover page."
        }
    }
    Message {
        MessageContent {
            variant: MessageContent.Muted
            text: "Done. Here's the PDF with the image added as the cover page."
            fileName: "sales-dashboard.pdf"
            fileMeta: "PDF · 2.4 MB"
        }
    }
    Message {
        align: Message.End
        MessageContent { variant: MessageContent.Default; text: "Thanks. Looks good." }
    }
}
