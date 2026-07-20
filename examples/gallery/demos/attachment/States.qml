import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 attachment-states:idle / uploading / processing / error / done。
// uploading、processing 标题微光;error 转 destructive 处理(失败原因写在描述里)。
ColumnLayout {
    width: 360
    spacing: 8

    Attachment {
        Layout.fillWidth: true
        uploadState: Attachment.Idle
        AttachmentMedia { iconName: "clock" }
        AttachmentContent {
            AttachmentName { text: "selected-file.pdf" }
            AttachmentSize { text: "Ready to upload" }
        }
        AttachmentActions {
            AttachmentAction { iconName: "x"; label: "Remove selected-file.pdf" }
        }
    }

    Attachment {
        Layout.fillWidth: true
        uploadState: Attachment.Uploading
        AttachmentMedia { Spinner {} }
        AttachmentContent {
            AttachmentName { text: "design-system.zip" }
            AttachmentSize { text: "Uploading · 64%" }
        }
        AttachmentActions {
            AttachmentAction { iconName: "x"; label: "Cancel upload" }
        }
    }

    Attachment {
        Layout.fillWidth: true
        uploadState: Attachment.Processing
        AttachmentMedia { iconName: "file-text" }
        AttachmentContent {
            AttachmentName { text: "market-research.pdf" }
            AttachmentSize { text: "Processing document" }
        }
        AttachmentActions {
            AttachmentAction { iconName: "x"; label: "Remove market-research.pdf" }
        }
    }

    Attachment {
        Layout.fillWidth: true
        uploadState: Attachment.Error
        AttachmentMedia { iconName: "file-warning" }
        AttachmentContent {
            AttachmentName { text: "financial-model.xlsx" }
            AttachmentSize { text: "Upload failed. Try again." }
        }
        AttachmentActions {
            AttachmentAction { iconName: "refresh-cw"; label: "Retry upload" }
            AttachmentAction { iconName: "x"; label: "Remove financial-model.xlsx" }
        }
    }

    Attachment {
        Layout.fillWidth: true
        uploadState: Attachment.Done
        AttachmentMedia { iconName: "check" }
        AttachmentContent {
            AttachmentName { text: "uploaded-report.pdf" }
            AttachmentSize { text: "Uploaded · 1.8 MB" }
        }
        AttachmentActions {
            AttachmentAction { iconName: "x"; label: "Remove uploaded-report.pdf" }
        }
    }
}
