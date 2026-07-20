import QtQuick
import QtQuick.Layouts
import Shadcn

// Menu —— 用纵向分隔线在带描述的菜单项之间分组。
RowLayout {
    spacing: 16

    ColumnLayout {
        spacing: 4
        Text {
            text: "Settings"
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.Medium
        }
        Text {
            text: "Manage preferences"
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
    }

    Separator { orientation: Separator.Vertical; Layout.preferredHeight: 32 }

    ColumnLayout {
        spacing: 4
        Text {
            text: "Account"
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.Medium
        }
        Text {
            text: "Profile & security"
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
    }

    Separator { orientation: Separator.Vertical; Layout.preferredHeight: 32 }

    ColumnLayout {
        spacing: 4
        Text {
            text: "Help"
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.Medium
        }
        Text {
            text: "Support & docs"
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
    }
}
