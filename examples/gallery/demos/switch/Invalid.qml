import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    width: 360
    spacing: 16

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        Label { text: "Accept terms and conditions" }
        Text {
            Layout.fillWidth: true
            text: "You must accept the terms and conditions to continue."
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            lineHeight: Theme.lineRelaxed
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
        }
    }
    Switch { invalid: true }
}
