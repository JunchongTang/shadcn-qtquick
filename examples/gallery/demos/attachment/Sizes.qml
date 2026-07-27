import QtQuick
import QtQuick.Layouts
import Shadcn

// Official attachment-sizes: default / sm / xs.
ColumnLayout {
    width: 360
    spacing: 12

    Attachment {
        Layout.fillWidth: true
        size: Attachment.Default
        AttachmentMedia { iconName: "file-text" }
        AttachmentContent {
            AttachmentName { text: qsTr("Default attachment") }
            AttachmentSize { text: qsTr("PDF · 2.4 MB") }
        }
    }

    Attachment {
        Layout.fillWidth: true
        size: Attachment.Sm
        AttachmentMedia { iconName: "file-text" }
        AttachmentContent {
            AttachmentName { text: qsTr("Small attachment") }
            AttachmentSize { text: qsTr("PDF · 2.4 MB") }
        }
    }

    Attachment {
        Layout.fillWidth: true
        size: Attachment.Xs
        AttachmentMedia { iconName: "file-text" }
        AttachmentContent {
            AttachmentName { text: qsTr("Extra small attachment") }
        }
    }
}
