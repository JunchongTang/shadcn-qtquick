import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 300
    spacing: 8

    Label { text: "Notification Preferences" }
    Text {
        Layout.fillWidth: true
        text: "Choose how you want to receive notifications."
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
    RadioGroup {
        Layout.topMargin: 4
        RadioButton { text: "Email only"; invalid: true; checked: true }
        RadioButton { text: "SMS only"; invalid: true }
        RadioButton { text: "Both Email & SMS"; invalid: true }
    }
}
