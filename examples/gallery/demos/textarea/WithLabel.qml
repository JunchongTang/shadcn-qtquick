import QtQuick
import QtQuick.Layouts
import Shadcn

// Field: label + description + textarea. Matches the frontend textarea-field.
ColumnLayout {
    width: 320
    spacing: 6

    Label {
        text: qsTr("Message")
        Layout.fillWidth: true
    }
    Text {
        Layout.fillWidth: true
        text: qsTr("Enter your message below.")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
    Textarea {
        Layout.fillWidth: true
        implicitHeight: 88
        placeholderText: qsTr("Type your message here.")
    }
}
