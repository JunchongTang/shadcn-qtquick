import QtQuick
import QtQuick.Layouts
import Shadcn

// Disabled: entire Field disabled (label dimmed + input non-editable). Mirrors the web <Field data-disabled>.
ColumnLayout {
    width: 260
    spacing: 6
    enabled: false

    Label {
        text: qsTr("Email")
        Layout.fillWidth: true
    }
    Input {
        Layout.fillWidth: true
        placeholderText: qsTr("Email")
    }
    Text {
        Layout.fillWidth: true
        text: qsTr("This field is currently disabled.")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        opacity: 0.5
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
