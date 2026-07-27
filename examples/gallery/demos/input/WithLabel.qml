import QtQuick
import QtQuick.Layouts
import Shadcn

// Field: label + input + description (vertical). Mirrors the web <Field><FieldLabel/><Input/><FieldDescription/>.
ColumnLayout {
    width: 260
    spacing: 6

    Label {
        text: qsTr("Username")
        Layout.fillWidth: true
    }
    Input {
        Layout.fillWidth: true
        placeholderText: qsTr("Enter your username")
    }
    Text {
        Layout.fillWidth: true
        text: qsTr("Choose a unique username for your account.")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
