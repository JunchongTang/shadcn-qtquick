import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 360

    ItemGroup {
        Layout.fillWidth: true

        Repeater {
            model: [
                { username: "shadcn",     avatar: "https://github.com/shadcn.png",     email: "shadcn@vercel.com" },
                { username: "maxleiter",  avatar: "https://github.com/maxleiter.png",  email: "maxleiter@vercel.com" },
                { username: "evilrabbit", avatar: "https://github.com/evilrabbit.png", email: "evilrabbit@vercel.com" }
            ]
            delegate: ShadItem {
                required property var modelData
                Layout.fillWidth: true
                variant: ShadItem.Outline

                ItemMedia {
                    Avatar {
                        source: modelData.avatar
                        fallback: modelData.username.charAt(0).toUpperCase()
                    }
                }
                ItemContent {
                    ItemTitle { text: modelData.username }
                    ItemDescription { text: modelData.email }
                }
                ItemActions {
                    Button {
                        variant: Button.Ghost
                        size: Button.Icon
                        rounded: true
                        iconName: "plus"
                    }
                }
            }
        }
    }
}
