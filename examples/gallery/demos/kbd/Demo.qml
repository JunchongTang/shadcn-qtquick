import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 kbd-demo:两组 KbdGroup —— 修饰键组(⌘⇧⌥⌃)与组合键(Ctrl + B,中间夹分隔符)。
ColumnLayout {
    spacing: Theme.space4                       // gap-4

    KbdGroup {
        Layout.alignment: Qt.AlignHCenter
        Kbd { text: "⌘" }                  // ⌘
        Kbd { text: "⇧" }                  // ⇧
        Kbd { text: "⌥" }                  // ⌥
        Kbd { text: "⌃" }                  // ⌃
    }

    KbdGroup {
        Layout.alignment: Qt.AlignHCenter
        Kbd { text: qsTr("Ctrl") }
        Text {
            text: "+"
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            font.family: Theme.fontSans
        }
        Kbd { text: qsTr("B") }
    }
}
