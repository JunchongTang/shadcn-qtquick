import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 attachment-trigger:全卡 Trigger 打开对话框预览,而 actions(复制/移除)仍独立可点。
// Trigger 覆盖层位于内容之下、actions 之下,故两者互不遮挡。
ColumnLayout {
    width: 360

    Attachment {
        Layout.fillWidth: true

        AttachmentMedia { iconName: "file-search" }
        AttachmentContent {
            AttachmentName { text: qsTr("research-summary.pdf") }
            AttachmentSize { text: qsTr("Open preview dialog") }
        }
        AttachmentActions {
            AttachmentAction { iconName: "copy"; label: qsTr("Copy link") }
            AttachmentAction { iconName: "x"; label: qsTr("Remove research-summary.pdf") }
        }
        AttachmentTrigger { label: qsTr("Preview research-summary.pdf") }
        onTriggered: previewDialog.open()
    }

    Dialog {
        id: previewDialog
        title: qsTr("research-summary.pdf")
        description: qsTr("The attachment trigger fills the card and opens the dialog, while the actions stay independently clickable above it.")
    }
}
