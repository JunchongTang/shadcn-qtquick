import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 360
    spacing: 6

    RowLayout {
        Layout.fillWidth: true
        Label { text: qsTr("Upload progress") }
        Item { Layout.fillWidth: true }
        Text {
            text: Math.round(bar.value) + "%"
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
    }
    Progress { id: bar; Layout.fillWidth: true; value: 56 }
}
