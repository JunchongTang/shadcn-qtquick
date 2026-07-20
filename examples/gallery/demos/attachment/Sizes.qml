import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 attachment-sizes:default / sm / xs。
ColumnLayout {
    width: 360
    spacing: 12

    Attachment {
        Layout.fillWidth: true
        size: Attachment.Default
        AttachmentMedia { iconName: "file-text" }
        AttachmentContent {
            AttachmentName { text: "Default attachment" }
            AttachmentSize { text: "PDF · 2.4 MB" }
        }
    }

    Attachment {
        Layout.fillWidth: true
        size: Attachment.Sm
        AttachmentMedia { iconName: "file-text" }
        AttachmentContent {
            AttachmentName { text: "Small attachment" }
            AttachmentSize { text: "PDF · 2.4 MB" }
        }
    }

    Attachment {
        Layout.fillWidth: true
        size: Attachment.Xs
        AttachmentMedia { iconName: "file-text" }
        AttachmentContent {
            AttachmentName { text: "Extra small attachment" }
        }
    }
}
