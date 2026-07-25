import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 300
    spacing: 12

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        Text {
            text: qsTr("Radix Primitives")
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.Medium
        }
        Text {
            text: qsTr("An open-source UI component library.")
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
    }

    Separator { Layout.fillWidth: true }

    RowLayout {
        spacing: 12
        Text { text: qsTr("Blog"); color: Theme.foreground; font.pixelSize: Theme.textXs }
        Separator { orientation: Separator.Vertical; Layout.preferredHeight: 16 }
        Text { text: qsTr("Docs"); color: Theme.foreground; font.pixelSize: Theme.textXs }
        Separator { orientation: Separator.Vertical; Layout.preferredHeight: 16 }
        Text { text: qsTr("Source"); color: Theme.foreground; font.pixelSize: Theme.textXs }
    }
}
