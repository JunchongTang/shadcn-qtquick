import QtQuick
import QtQuick.Layouts
import Shadcn

// Vertical — vertical dividers between a row of text labels.
RowLayout {
    spacing: 16

    Text { text: qsTr("Blog"); color: Theme.foreground; font.pixelSize: Theme.textSm }
    Separator { orientation: Separator.Vertical; Layout.preferredHeight: 20 }
    Text { text: qsTr("Docs"); color: Theme.foreground; font.pixelSize: Theme.textSm }
    Separator { orientation: Separator.Vertical; Layout.preferredHeight: 20 }
    Text { text: qsTr("Source"); color: Theme.foreground; font.pixelSize: Theme.textSm }
}
