import QtQuick
import QtQuick.Layouts
import Shadcn

// Textarea + submit button. Matches the frontend textarea-button.
ColumnLayout {
    width: 320
    spacing: 8

    Textarea {
        Layout.fillWidth: true
        implicitHeight: 88
        placeholderText: qsTr("Type your message here.")
    }
    Button {
        Layout.fillWidth: true
        text: qsTr("Send message")
    }
}
