import QtQuick
import QtQuick.Layouts
import Shadcn

// Disabled: the whole Field is disabled. Matches the frontend <Field data-disabled>.
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
