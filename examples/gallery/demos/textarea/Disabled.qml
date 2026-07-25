import QtQuick
import QtQuick.Layouts
import Shadcn

// Disabled: 整个 Field 禁用。对标前端 <Field data-disabled>。
ColumnLayout {
    width: 320
    spacing: 6
    enabled: false

    Label {
        text: qsTr("Message")
        Layout.fillWidth: true
    }
    Textarea {
        Layout.fillWidth: true
        implicitHeight: 88
        placeholderText: qsTr("Type your message here.")
    }
}
