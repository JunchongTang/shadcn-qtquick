import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// 悬停链接式触发,弹出用户名片:头像 + 用户名 + 简介 + 加入时间。
Button {
    id: trigger
    text: "@nextjs"
    variant: Button.Link

    HoverCard {
        id: card
        delay: 10
        closeDelay: 100
        cardWidth: 256                       // w-64

        RowLayout {
            width: card.availableWidth
            spacing: 12                      // gap-3

            Avatar {
                size: Avatar.Lg
                fallback: "VC"
                source: "https://github.com/vercel.png"
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: "@nextjs"
                    color: Theme.foreground
                    font.pixelSize: Theme.textXs
                    font.weight: Font.DemiBold
                }
                Text {
                    Layout.fillWidth: true
                    text: "The React Framework – created and maintained by @vercel."
                    color: Theme.foreground
                    font.pixelSize: Theme.textXs
                    lineHeight: Theme.lineRelaxed
                    lineHeightMode: Text.ProportionalHeight
                    wrapMode: Text.Wrap
                }
                RowLayout {
                    Layout.topMargin: 4
                    spacing: 4
                    LucideIcon {
                        name: "calendar-days"
                        size: 14
                        color: Theme.mutedForeground
                    }
                    Text {
                        text: "Joined December 2021"
                        color: Theme.mutedForeground
                        font.pixelSize: Theme.textXs
                    }
                }
            }
        }
    }
}
