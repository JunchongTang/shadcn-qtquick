import QtQuick
import QtQuick.Layouts
import Shadcn

// Official attachment-image: variant="image" + orientation="vertical", media on top, content below,
// with a remove action and a full-card Trigger (approximated here by opening the image in an external browser).
ColumnLayout {
    width: 360

    AttachmentGroup {
        Layout.fillWidth: true

        Repeater {
            model: [
                { name: "workspace.png",        meta: "PNG · 820 KB", seed: "301" },
                { name: "desk-reference.jpg",   meta: "JPG · 1.1 MB", seed: "302" },
                { name: "office-reference.jpg", meta: "JPG · 940 KB", seed: "303" }
            ]
            delegate: Attachment {
                required property var modelData
                readonly property url imgUrl: "https://picsum.photos/seed/" + modelData.seed + "/480"
                orientation: Attachment.Vertical

                AttachmentMedia {
                    variant: AttachmentMedia.Image
                    source: imgUrl
                }
                AttachmentContent {
                    AttachmentName { text: modelData.name }
                    AttachmentSize { text: modelData.meta }
                }
                AttachmentActions {
                    AttachmentAction { iconName: "x"; label: qsTr("Remove ") + modelData.name }
                }
                AttachmentTrigger { label: qsTr("Open ") + modelData.name }
                onTriggered: Qt.openUrlExternally(imgUrl)
            }
        }
    }
}
