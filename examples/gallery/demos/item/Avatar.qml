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
            ItemTitle { text: "Evil Rabbit" }
            ItemDescription { text: "Last seen 5 months ago" }
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
            // 头像组:-space-x-2 重叠 + 与背景同色的 ring。
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
            ItemTitle { text: "No Team Members" }
            ItemDescription { text: "Invite your team to collaborate on this project." }
        }
        ItemActions {
            Button { text: "Invite"; variant: Button.Outline; size: Button.Sm }
        }
    }
}
