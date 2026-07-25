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
            AttachmentName { text: qsTr("selected-file.pdf") }
            AttachmentSize { text: qsTr("Ready to upload") }
        }
        AttachmentActions {
            AttachmentAction { iconName: "x"; label: qsTr("Remove selected-file.pdf") }
        }
    }

    Attachment {
        Layout.fillWidth: true
        uploadState: Attachment.Uploading
        AttachmentMedia { Spinner {} }
        AttachmentContent {
            AttachmentName { text: qsTr("design-system.zip") }
            AttachmentSize { text: qsTr("Uploading · 64%") }
        }
        AttachmentActions {
            AttachmentAction { iconName: "x"; label: qsTr("Cancel upload") }
        }
    }

    Attachment {
        Layout.fillWidth: true
        uploadState: Attachment.Processing
        AttachmentMedia { iconName: "file-text" }
        AttachmentContent {
            AttachmentName { text: qsTr("market-research.pdf") }
            AttachmentSize { text: qsTr("Processing document") }
        }
        AttachmentActions {
            AttachmentAction { iconName: "x"; label: qsTr("Remove market-research.pdf") }
        }
    }

    Attachment {
        Layout.fillWidth: true
        uploadState: Attachment.Error
        AttachmentMedia { iconName: "file-warning" }
        AttachmentContent {
            AttachmentName { text: qsTr("financial-model.xlsx") }
            AttachmentSize { text: qsTr("Upload failed. Try again.") }
        }
        AttachmentActions {
            AttachmentAction { iconName: "refresh-cw"; label: qsTr("Retry upload") }
            AttachmentAction { iconName: "x"; label: qsTr("Remove financial-model.xlsx") }
        }
    }

    Attachment {
        Layout.fillWidth: true
        uploadState: Attachment.Done
        AttachmentMedia { iconName: "check" }
        AttachmentContent {
            AttachmentName { text: qsTr("uploaded-report.pdf") }
            AttachmentSize { text: qsTr("Uploaded · 1.8 MB") }
        }
        AttachmentActions {
            AttachmentAction { iconName: "x"; label: qsTr("Remove uploaded-report.pdf") }
        }
    }
}
