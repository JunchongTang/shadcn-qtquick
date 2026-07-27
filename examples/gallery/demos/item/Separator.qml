import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Use ItemSeparator inside an ItemGroup to add a divider between adjacent Items (my-2 spacing).
ColumnLayout {
    width: 380

    ItemGroup {
        Layout.fillWidth: true

        ShadItem {
            Layout.fillWidth: true
            asLink: true
            ItemMedia { variant: ItemMedia.Icon; iconName: "user" }
            ItemContent { ItemTitle { text: qsTr("Profile") } }
            ItemActions { LucideIcon { name: "chevron-right"; size: 16; color: Theme.mutedForeground } }
        }
        ItemSeparator {}
        ShadItem {
            Layout.fillWidth: true
            asLink: true
            ItemMedia { variant: ItemMedia.Icon; iconName: "settings" }
            ItemContent { ItemTitle { text: qsTr("Settings") } }
            ItemActions { LucideIcon { name: "chevron-right"; size: 16; color: Theme.mutedForeground } }
        }
        ItemSeparator {}
        ShadItem {
            Layout.fillWidth: true
            asLink: true
            ItemMedia { variant: ItemMedia.Icon; iconName: "log-out" }
            ItemContent { ItemTitle { text: qsTr("Log out") } }
            ItemActions { LucideIcon { name: "chevron-right"; size: 16; color: Theme.mutedForeground } }
        }
    }
}
