import QtQuick
import QtQuick.Layouts
import Shadcn

// Required: label with a red asterisk marking it mandatory. Mirrors the web <FieldLabel>… <span className="text-destructive">*</span>.
ColumnLayout {
    width: 260
    spacing: 6

    // Label + destructive asterisk composed inline (no separate Field component).
    RowLayout {
        Layout.fillWidth: true
        spacing: 2
        Label { text: qsTr("Required Field") }
        Label {
            text: "*"
            color: Theme.destructive
        }
    }
    Input {
        Layout.fillWidth: true
        placeholderText: qsTr("This field is required")
    }
    Text {
        Layout.fillWidth: true
        text: qsTr("This field must be filled out.")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
