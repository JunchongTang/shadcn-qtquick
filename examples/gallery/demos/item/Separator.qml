import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// ItemGroup 内用 ItemSeparator 在相邻 Item 之间加分隔线(my-2 留白)。
ColumnLayout {
    width: 380

    ItemGroup {
        Layout.fillWidth: true

        ShadItem {
            Layout.fillWidth: true
            asLink: true
            ItemMedia { variant: ItemMedia.Icon; iconName: "user" }
            ItemContent { ItemTitle { text: "Profile" } }
            ItemActions { LucideIcon { name: "chevron-right"; size: 16; color: Theme.mutedForeground } }
        }
        ItemSeparator {}
        ShadItem {
            Layout.fillWidth: true
            asLink: true
            ItemMedia { variant: ItemMedia.Icon; iconName: "settings" }
            ItemContent { ItemTitle { text: "Settings" } }
            ItemActions { LucideIcon { name: "chevron-right"; size: 16; color: Theme.mutedForeground } }
        }
        ItemSeparator {}
        ShadItem {
            Layout.fillWidth: true
            asLink: true
            ItemMedia { variant: ItemMedia.Icon; iconName: "log-out" }
            ItemContent { ItemTitle { text: "Log out" } }
            ItemActions { LucideIcon { name: "chevron-right"; size: 16; color: Theme.mutedForeground } }
        }
    }
}
