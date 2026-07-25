import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 kbd-group:在一句说明文字中内联一组 KbdGroup(每个 Kbd 是完整快捷键)。
RowLayout {
    spacing: Theme.space1_5

    Text {
        text: qsTr("Use")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textSm
        font.family: Theme.fontSans
    }
    KbdGroup {
        Kbd { text: qsTr("Ctrl + B") }
        Kbd { text: qsTr("Ctrl + K") }
    }
    Text {
        text: qsTr("to open the command palette")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textSm
        font.family: Theme.fontSans
    }
}
