import QtQuick
import QtQuick.Layouts
import Shadcn

// Official attachment-demo: a row of vertical image attachments + an uploading card + a completed file card.
ColumnLayout {
    width: 360
    spacing: 12

    AttachmentGroup {
        Layout.fillWidth: true

        Repeater {
            model: [
                { name: "workspace.png",        meta: "PNG · 820 KB", seed: "101" },
                { name: "desk-reference.jpg",   meta: "JPG · 1.1 MB", seed: "102" },
                { name: "office-reference.jpg", meta: "JPG · 940 KB", seed: "103" }
            ]
            delegate: Attachment {
                required property var modelData
                orientation: Attachment.Vertical

                AttachmentMedia {
                    variant: AttachmentMedia.Image
                    source: "https://picsum.photos/seed/" + modelData.seed + "/240"
                }
                AttachmentContent {
                    AttachmentName { text: modelData.name }
                    AttachmentSize { text: modelData.meta }
                }
            }
        }
    }

    // Uploading: spinner media + progress text.
    Attachment {
        Layout.fillWidth: true
        uploadState: Attachment.Uploading

        AttachmentMedia {
            Spinner {}
        }
        AttachmentContent {
            AttachmentName { text: qsTr("sales-dashboard.pdf") }
            AttachmentSize { text: qsTr("Uploading · 64%") }
        }
        AttachmentActions {
            AttachmentAction { iconName: "x"; label: qsTr("Cancel upload") }
        }
    }

    // Completed file card.
    Attachment {
        Layout.fillWidth: true

        AttachmentMedia { iconName: "file-code" }
        AttachmentContent {
            AttachmentName { text: qsTr("message-renderer.tsx") }
            AttachmentSize { text: qsTr("TypeScript · 12 KB") }
        }
        AttachmentActions {
            AttachmentAction { iconName: "x"; label: qsTr("Remove message-renderer.tsx") }
        }
    }
}
