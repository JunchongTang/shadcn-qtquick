import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 300
    spacing: 12

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        Text {
            text: "Radix Primitives"
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.Medium
        }
        Text {
            text: "An open-source UI component library."
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
    }

    Separator { Layout.fillWidth: true }

    RowLayout {
        spacing: 12
        Text { text: "Blog"; color: Theme.foreground; font.pixelSize: Theme.textXs }
        Separator { orientation: Separator.Vertical; Layout.preferredHeight: 16 }
        Text { text: "Docs"; color: Theme.foreground; font.pixelSize: Theme.textXs }
        Separator { orientation: Separator.Vertical; Layout.preferredHeight: 16 }
        Text { text: "Source"; color: Theme.foreground; font.pixelSize: Theme.textXs }
    }
}
