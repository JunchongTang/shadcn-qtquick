import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

Rectangle {
    color: Theme.background
    implicitWidth: 560
    implicitHeight: 240

    Button {
        id: trigger
        anchors.horizontalCenter: parent.horizontalCenter
        y: 40
        text: qsTr("@nextjs")
        variant: Button.Link

        HoverCard {
            id: card
            cardWidth: 256

            RowLayout {
                width: card.availableWidth
                spacing: 12

                Avatar {
                    size: Avatar.Lg
                    fallback: "VC"
                    source: "https://github.com/vercel.png"
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: qsTr("@nextjs")
                        color: Theme.foreground
                        font.pixelSize: Theme.textXs
                        font.weight: Font.DemiBold
                    }
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("The React Framework – created and maintained by @vercel.")
                        color: Theme.foreground
                        font.pixelSize: Theme.textXs
                        lineHeight: Theme.lineRelaxed
                        lineHeightMode: Text.ProportionalHeight
                        wrapMode: Text.Wrap
                    }
                    RowLayout {
                        Layout.topMargin: 4
                        spacing: 4
                        LucideIcon { name: "calendar-days"; size: 14; color: Theme.mutedForeground }
                        Text { text: qsTr("Joined December 2021"); color: Theme.mutedForeground; font.pixelSize: Theme.textXs }
                    }
                }
            }
        }
    }

    // Force the hover-driven card open for the screenshot.
    Component.onCompleted: { card._triggerHovered = true; card._sync() }
}
