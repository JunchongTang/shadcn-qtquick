import QtQuick
import QtQuick.Layouts
import Shadcn

// Field (data-invalid): label + destructive-colored input + description. Mirrors the web aria-invalid.
ColumnLayout {
    width: 260
    spacing: 6

    Label {
        text: qsTr("Invalid Input")
        Layout.fillWidth: true
    }
    Input {
        Layout.fillWidth: true
        placeholderText: qsTr("Error")
        invalid: true
    }
    Text {
        Layout.fillWidth: true
        text: qsTr("This field contains validation errors.")
        color: Theme.destructive
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
