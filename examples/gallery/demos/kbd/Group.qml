import QtQuick
import QtQuick.Layouts
import Shadcn

// Official kbd-group: inline a KbdGroup within a line of explanatory text (each Kbd is a full shortcut).
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
