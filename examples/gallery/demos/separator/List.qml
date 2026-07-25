import QtQuick
import QtQuick.Layouts
import Shadcn

// List —— 列表项之间用水平分隔线。
ColumnLayout {
    width: 300
    spacing: 8

    RowLayout {
        Layout.fillWidth: true
        Text { text: qsTr("Item 1"); color: Theme.foreground; font.pixelSize: Theme.textSm }
        Item { Layout.fillWidth: true }
        Text { text: qsTr("Value 1"); color: Theme.mutedForeground; font.pixelSize: Theme.textSm }
    }

    Separator { Layout.fillWidth: true }

    RowLayout {
        Layout.fillWidth: true
        Text { text: qsTr("Item 2"); color: Theme.foreground; font.pixelSize: Theme.textSm }
        Item { Layout.fillWidth: true }
        Text { text: qsTr("Value 2"); color: Theme.mutedForeground; font.pixelSize: Theme.textSm }
    }

    Separator { Layout.fillWidth: true }

    RowLayout {
        Layout.fillWidth: true
        Text { text: qsTr("Item 3"); color: Theme.foreground; font.pixelSize: Theme.textSm }
        Item { Layout.fillWidth: true }
        Text { text: qsTr("Value 3"); color: Theme.mutedForeground; font.pixelSize: Theme.textSm }
    }
}
