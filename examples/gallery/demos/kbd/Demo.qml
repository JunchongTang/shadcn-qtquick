import QtQuick
import QtQuick.Layouts
import Shadcn

// Official kbd-demo: two KbdGroups — a modifier group (⌘⇧⌥⌃) and a combo (Ctrl + B, with a separator between).
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
