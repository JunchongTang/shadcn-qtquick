import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 300
    spacing: 8

    Label { text: qsTr("Notification Preferences") }
    Text {
        Layout.fillWidth: true
        text: qsTr("Choose how you want to receive notifications.")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
    RadioGroup {
        Layout.topMargin: 4
        RadioButton { text: qsTr("Email only"); invalid: true; checked: true }
        RadioButton { text: qsTr("SMS only"); invalid: true }
        RadioButton { text: qsTr("Both Email & SMS"); invalid: true }
    }
}
