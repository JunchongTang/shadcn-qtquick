import QtQuick
import QtQuick.Layouts
import Shadcn

// Official collapsible-demo —— "Order #4189": title + icon trigger stay pinned,
// status row stays pinned; expanding reveals two bordered cards (shipping address /
// item details).
Collapsible {
    id: c
    width: 350
    gap: 8

    // ---- Pinned area: title row + status row ----
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

    // ---- Collapsible content: two detail cards ----
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
