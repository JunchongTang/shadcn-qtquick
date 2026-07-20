import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 420
    spacing: 24

    ShadItem {
        Layout.fillWidth: true
        ItemMedia { variant: ItemMedia.Icon; iconName: "inbox" }
        ItemContent {
            ItemTitle { text: "Default Variant" }
            ItemDescription { text: "Transparent background with no border." }
        }
    }

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline
        ItemMedia { variant: ItemMedia.Icon; iconName: "inbox" }
        ItemContent {
            ItemTitle { text: "Outline Variant" }
            ItemDescription { text: "Outlined style with a visible border." }
        }
    }

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Muted
        ItemMedia { variant: ItemMedia.Icon; iconName: "inbox" }
        ItemContent {
            ItemTitle { text: "Muted Variant" }
            ItemDescription { text: "Muted background for secondary content." }
        }
    }
}
