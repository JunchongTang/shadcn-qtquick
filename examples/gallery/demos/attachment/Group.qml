import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 attachment-group:横向可滚动的一行,混合文件类型图标与图片缩略。
ColumnLayout {
    width: 360

    AttachmentGroup {
        Layout.fillWidth: true

        Repeater {
            model: [
                { name: "briefing-notes.pdf", meta: "PDF · 1.4 MB", icon: "file-text" },
                { name: "workspace.png",      meta: "PNG · 820 KB", seed: "201" },
                { name: "customers.csv",      meta: "CSV · 18 KB",  icon: "table" },
                { name: "renderer.tsx",       meta: "TSX · 12 KB",  icon: "file-code" }
            ]
            delegate: Attachment {
                required property var modelData
                width: 256                       // w-64

                AttachmentMedia {
                    variant: modelData.seed ? AttachmentMedia.Image
                                            : AttachmentMedia.Icon
                    iconName: modelData.icon ? modelData.icon : ""
                    source: modelData.seed ? "https://picsum.photos/seed/" + modelData.seed + "/120" : ""
                }
                AttachmentContent {
                    AttachmentName { text: modelData.name }
                    AttachmentSize { text: modelData.meta }
                }
                AttachmentActions {
                    AttachmentAction { iconName: "x"; label: qsTr("Remove ") + modelData.name }
                }
            }
        }
    }
}
