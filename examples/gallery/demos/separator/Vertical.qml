import QtQuick
import QtQuick.Layouts
import Shadcn

// Vertical —— 纵向分隔线在一行文本之间。
RowLayout {
    spacing: 16

    Text { text: qsTr("Blog"); color: Theme.foreground; font.pixelSize: Theme.textSm }
    Separator { orientation: Separator.Vertical; Layout.preferredHeight: 20 }
    Text { text: qsTr("Docs"); color: Theme.foreground; font.pixelSize: Theme.textSm }
    Separator { orientation: Separator.Vertical; Layout.preferredHeight: 20 }
    Text { text: qsTr("Source"); color: Theme.foreground; font.pixelSize: Theme.textSm }
}
