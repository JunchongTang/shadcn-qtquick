import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Use asLink to make the whole row a clickable link: bg-muted on hover, pointer cursor, focusable (focus ring).
ColumnLayout {
    width: 420
    spacing: 16

    ShadItem {
        Layout.fillWidth: true
        asLink: true
        ItemContent {
            ItemTitle { text: qsTr("Visit our documentation") }
            ItemDescription { text: qsTr("Learn how to get started with our components.") }
        }
        ItemActions {
            LucideIcon { name: "chevron-right"; size: 16; color: Theme.mutedForeground }
        }
    }

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline
        asLink: true
        ItemContent {
            ItemTitle { text: qsTr("External resource") }
            ItemDescription { text: qsTr("Opens in a new tab with security attributes.") }
        }
        ItemActions {
            LucideIcon { name: "external-link"; size: 16; color: Theme.mutedForeground }
        }
    }
}
