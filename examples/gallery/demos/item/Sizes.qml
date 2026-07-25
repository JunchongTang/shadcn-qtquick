import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 420
    spacing: 24

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline
        ItemMedia { variant: ItemMedia.Icon; iconName: "inbox" }
        ItemContent {
            ItemTitle { text: qsTr("Default Size") }
            ItemDescription { text: qsTr("The standard size for most use cases.") }
        }
    }

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline
        size: ShadItem.Sm
        ItemMedia { variant: ItemMedia.Icon; iconName: "inbox" }
        ItemContent {
            ItemTitle { text: qsTr("Small Size") }
            ItemDescription { text: qsTr("A compact size for dense layouts.") }
        }
    }

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline
        size: ShadItem.Xs
        ItemMedia { variant: ItemMedia.Icon; iconName: "inbox" }
        ItemContent {
            ItemTitle { text: qsTr("Extra Small Size") }
            ItemDescription { text: qsTr("The most compact size available.") }
        }
    }
}
