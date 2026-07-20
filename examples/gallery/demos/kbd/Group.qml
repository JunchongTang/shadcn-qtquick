import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 kbd-group:在一句说明文字中内联一组 KbdGroup(每个 Kbd 是完整快捷键)。
RowLayout {
    spacing: Theme.space1_5

    Text {
        text: "Use"
        color: Theme.mutedForeground
        font.pixelSize: Theme.textSm
        font.family: Theme.fontSans
    }
    KbdGroup {
        Kbd { text: "Ctrl + B" }
        Kbd { text: "Ctrl + K" }
    }
    Text {
        text: "to open the command palette"
        color: Theme.mutedForeground
        font.pixelSize: Theme.textSm
        font.family: Theme.fontSans
    }
}
