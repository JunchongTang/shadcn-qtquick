import QtQuick
import QtQuick.Layouts
import Shadcn

// Card Image —— 对标官方 card-image:卡片顶部一张贴边封面图(aspect-video、圆角上沿)。
// 图片是卡片首个子项 → 去掉顶部内边距(has-[>img:first-child]:pt-0),并向上/左/右
// 各用 -cardSpacing 负边距铺满到卡片边缘;顶部两角圆角对齐卡片圆角(*:[img:first-child]:rounded-t-lg)。
Card {
    id: card
    width: 340

    // ==== 顶部封面(Rectangle 占位色 + 暗化遮罩,等价 <img> + bg-black/35)====
    Item {
        Layout.fillWidth: true
        Layout.leftMargin: -card.cardSpacing
        Layout.rightMargin: -card.cardSpacing
        Layout.topMargin: -card.cardSpacing
        Layout.preferredHeight: width * 9 / 16   // aspect-video

        Rectangle {
            anchors.fill: parent
            topLeftRadius: Theme.radiusLg
            topRightRadius: Theme.radiusLg
            color: Theme.secondary               // 占位封面色
        }
        // 暗化遮罩(bg-black/35)
        Rectangle {
            anchors.fill: parent
            topLeftRadius: Theme.radiusLg
            topRightRadius: Theme.radiusLg
            color: Theme.alpha("#000000", 0.35)
        }
        Text {
            anchors.centerIn: parent
            text: qsTr("Event cover")
            color: Theme.alpha("#ffffff", 0.85)
            font.pixelSize: Theme.textSm
            font.weight: Font.Medium
        }
    }

    CardHeader {
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.space2
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.space1
                CardTitle { text: qsTr("Design systems meetup") }
                CardDescription { text: qsTr("A practical talk on component APIs, accessibility, and shipping faster.") }
            }
            Badge { text: qsTr("Featured"); variant: Badge.Secondary; Layout.alignment: Qt.AlignTop }
        }
    }

    CardFooter {
        Button { Layout.fillWidth: true; text: qsTr("View Event") }
    }
}
