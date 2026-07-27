import QtQuick
import QtQuick.Layouts
import Shadcn

// Menu — vertical dividers group menu items with descriptions.
RowLayout {
    spacing: 16

    ColumnLayout {
        spacing: 4
        Text {
            text: qsTr("Settings")
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.Medium
        }
        Text {
            text: qsTr("Manage preferences")
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
    }

    Separator { orientation: Separator.Vertical; Layout.preferredHeight: 32 }

    ColumnLayout {
        spacing: 4
        Text {
            text: qsTr("Account")
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.Medium
        }
        Text {
            text: qsTr("Profile & security")
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
    }

    Separator { orientation: Separator.Vertical; Layout.preferredHeight: 32 }

    ColumnLayout {
        spacing: 4
        Text {
            text: qsTr("Help")
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.Medium
        }
        Text {
            text: qsTr("Support & docs")
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
    }
}
