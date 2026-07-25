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
            ItemTitle { text: qsTr("Default Variant") }
            ItemDescription { text: qsTr("Transparent background with no border.") }
        }
    }

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline
        ItemMedia { variant: ItemMedia.Icon; iconName: "inbox" }
        ItemContent {
            ItemTitle { text: qsTr("Outline Variant") }
            ItemDescription { text: qsTr("Outlined style with a visible border.") }
        }
    }

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Muted
        ItemMedia { variant: ItemMedia.Icon; iconName: "inbox" }
        ItemContent {
            ItemTitle { text: qsTr("Muted Variant") }
            ItemDescription { text: qsTr("Muted background for secondary content.") }
        }
    }
}
