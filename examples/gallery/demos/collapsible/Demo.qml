import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 collapsible-demo —— 「Order #4189」:标题 + 图标触发器常驻,
// 状态行常驻,展开后揭示配送地址/商品明细两张边框卡。
Collapsible {
    id: c
    width: 350
    gap: 8

    // ---- 常驻区:标题行 + 状态行 ----
    trigger: ColumnLayout {
        width: parent.width
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            spacing: 16
            Text {
                text: qsTr("Order #4189")
                color: Theme.foreground
                font.pixelSize: Theme.textSm
                font.weight: Font.DemiBold
            }
            Item { Layout.fillWidth: true }
            Button {
                variant: Button.Ghost
                size: Button.Icon
                iconName: "chevrons-up-down"
                onClicked: c.toggle()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: statusRow.implicitHeight + 16
            radius: Theme.radiusMd
            color: "transparent"
            border.width: 1
            border.color: Theme.border
            RowLayout {
                id: statusRow
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                Text {
                    text: qsTr("Status")
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textSm
                }
                Item { Layout.fillWidth: true }
                Text {
                    text: qsTr("Shipped")
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm
                    font.weight: Font.Medium
                }
            }
        }
    }

    // ---- 可折叠内容:两张明细卡 ----
    component InfoCard: Rectangle {
        id: cardRoot
        property string heading: ""
        property string detail: ""
        Layout.fillWidth: true
        implicitHeight: cardBody.implicitHeight + 16
        radius: Theme.radiusMd
        color: "transparent"
        border.width: 1
        border.color: Theme.border
        ColumnLayout {
            id: cardBody
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 0
            Text {
                text: cardRoot.heading
                color: Theme.foreground
                font.pixelSize: Theme.textSm
                font.weight: Font.Medium
            }
            Text {
                Layout.fillWidth: true
                text: cardRoot.detail
                color: Theme.mutedForeground
                font.pixelSize: Theme.textSm
                wrapMode: Text.Wrap
            }
        }
    }

    InfoCard { heading: qsTr("Shipping address"); detail: "100 Market St, San Francisco" }
    InfoCard { heading: qsTr("Items"); detail: "2x Studio Headphones" }
}
