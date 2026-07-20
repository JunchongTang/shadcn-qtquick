import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// 官方 collapsible-basic —— 卡片内一个可折叠区块:全宽 ghost 触发器(文本 + 右侧
// chevron 旋转),展开后揭示说明文本与「Learn More」按钮。展开时整块背景转为 muted。
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
                        text: "Product details"
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

            // ---- 可折叠内容(p-2.5 pt-0)----
            Text {
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                text: "This panel can be expanded or collapsed to reveal additional content."
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                lineHeight: Theme.lineRelaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
            }
            Button {
                Layout.leftMargin: 10
                Layout.bottomMargin: 10
                text: "Learn More"
                size: Button.Xs
            }
        }
    }
}
