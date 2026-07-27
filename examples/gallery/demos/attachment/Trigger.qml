import QtQuick
import QtQuick.Layouts
import Shadcn

// Official attachment-trigger: a full-card Trigger opens a preview dialog, while actions (copy/remove) stay independently clickable.
// The Trigger overlay sits below the content and below the actions, so the two never occlude each other.
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
