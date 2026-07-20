import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

ColumnLayout {
    width: 420
    spacing: 24

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline

        ItemContent {
            ItemTitle { text: "Basic Item" }
            ItemDescription { text: "A simple item with title and description." }
        }
        ItemActions {
            Button { text: "Action"; variant: Button.Outline; size: Button.Sm }
        }
    }

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline
        size: ShadItem.Sm
        asLink: true

        ItemMedia {
            LucideIcon { name: "badge-check"; size: 20; color: Theme.foreground }
        }
        ItemContent {
            ItemTitle { text: "Your profile has been verified." }
        }
        ItemActions {
            LucideIcon { name: "chevron-right"; size: 16; color: Theme.mutedForeground }
        }
    }
}
