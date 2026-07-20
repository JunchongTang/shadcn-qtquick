import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 460
    spacing: 24

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline
        ItemMedia { variant: ItemMedia.Icon; iconName: "shield-alert" }
        ItemContent {
            ItemTitle { text: "Security Alert" }
            ItemDescription { text: "New login detected from unknown device." }
        }
        ItemActions {
            Button { text: "Review"; variant: Button.Outline; size: Button.Sm }
        }
    }
}
