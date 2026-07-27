import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

ColumnLayout {
    width: 460
    spacing: 24

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline
        ItemMedia {
            Avatar { size: Avatar.Lg; source: "https://github.com/evilrabbit.png"; fallback: "ER" }
        }
        ItemContent {
            ItemTitle { text: qsTr("Evil Rabbit") }
            ItemDescription { text: qsTr("Last seen 5 months ago") }
        }
        ItemActions {
            Button {
                variant: Button.Outline
                size: Button.IconSm
                rounded: true
                iconName: "plus"
            }
        }
    }

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline
        ItemMedia {
            // Avatar stack: -space-x-2 overlap + ring matching the background color.
            Row {
                spacing: -8
                Repeater {
                    model: ["https://github.com/shadcn.png",
                            "https://github.com/maxleiter.png",
                            "https://github.com/evilrabbit.png"]
                    delegate: Avatar {
                        required property string modelData
                        source: modelData
                        fallback: "U"
                        border.width: 2
                        border.color: Theme.background
                    }
                }
            }
        }
        ItemContent {
            ItemTitle { text: qsTr("No Team Members") }
            ItemDescription { text: qsTr("Invite your team to collaborate on this project.") }
        }
        ItemActions {
            Button { text: qsTr("Invite"); variant: Button.Outline; size: Button.Sm }
        }
    }
}
