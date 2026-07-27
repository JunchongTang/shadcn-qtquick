import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Official collapsible-basic —— a collapsible section inside a card: full-width ghost
// trigger (text + chevron rotation on the right), expanding to reveal descriptive text
// and a "Learn More" button. Background turns muted while expanded.
Card {
    width: 360

    CardContent {
        Collapsible {
            id: c
            Layout.fillWidth: true
            radius: Theme.radiusMd
            background: expanded ? Theme.muted : "transparent"
            gap: 8

            trigger: Rectangle {
                width: parent.width
                implicitHeight: 28
                radius: Theme.radiusMd
                color: hover.hovered ? Theme.muted : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 8
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Product details")
                        color: Theme.foreground
                        font.pixelSize: Theme.textXs
                        font.weight: Font.Medium
                    }
                    LucideIcon {
                        name: "chevron-down"
                        size: 16
                        color: Theme.foreground
                        rotation: c.expanded ? 180 : 0
                        Behavior on rotation { NumberAnimation { duration: Theme.durFast } }
                    }
                }

                HoverHandler { id: hover }
                TapHandler { onTapped: c.toggle() }
            }

            // ---- Collapsible content (p-2.5 pt-0) ----
            Text {
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                text: qsTr("This panel can be expanded or collapsed to reveal additional content.")
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                lineHeight: Theme.lineRelaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
            }
            Button {
                Layout.leftMargin: 10
                Layout.bottomMargin: 10
                text: qsTr("Learn More")
                size: Button.Xs
            }
        }
    }
}
