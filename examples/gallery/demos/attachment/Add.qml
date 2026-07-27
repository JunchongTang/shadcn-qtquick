import QtQuick
import QtQuick.Layouts
import Shadcn

// Extra section (not an official standalone one; approximates the described "add attachment button / drop zone"):
// uses the idle dashed state + full-card Trigger to approximate a "click to add / drag-drop upload" entry point.
// Note: real file selection and drag-drop logic are not implemented here; this only statically approximates the interaction (a click bumps a counter).
ColumnLayout {
    id: root
    width: 360
    spacing: 10

    property int _added: 0

    Attachment {
        Layout.fillWidth: true
        uploadState: Attachment.Idle          // dashed border → drop-zone look

        AttachmentMedia { iconName: "upload" }
        AttachmentContent {
            AttachmentName { text: qsTr("Add attachment") }
            AttachmentSize { text: qsTr("Drag and drop or click to browse") }
        }
        AttachmentTrigger { label: qsTr("Add attachment") }
        onTriggered: root._added++
    }

    Text {
        visible: root._added > 0
        text: root._added + " file(s) added (demo)"
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
    }
}
