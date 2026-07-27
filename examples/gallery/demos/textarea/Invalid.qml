import QtQuick
import QtQuick.Layouts
import Shadcn

// Field (data-invalid): label + destructive-colored textarea + description. Matches the frontend aria-invalid.
ColumnLayout {
    width: 320
    spacing: 6

    Label {
        text: qsTr("Message")
        Layout.fillWidth: true
    }
    Textarea {
        Layout.fillWidth: true
        implicitHeight: 88
        placeholderText: qsTr("Type your message here.")
        invalid: true
    }
    Text {
        Layout.fillWidth: true
        text: qsTr("Please enter a valid message.")
        color: Theme.destructive
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
