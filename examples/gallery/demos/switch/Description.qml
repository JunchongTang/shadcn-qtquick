import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    width: 360
    spacing: 16

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        Label { text: "Share across devices" }
        Text {
            Layout.fillWidth: true
            text: "Focus is shared across devices, and turns off when you leave the app."
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            lineHeight: Theme.lineRelaxed
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
        }
    }
    Switch {}
}
