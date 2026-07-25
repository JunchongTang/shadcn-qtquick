import QtQuick
import QtQuick.Layouts
import Shadcn

// 展示 ItemHeader / ItemContent / ItemFooter 三段布局(header、footer 各占整行,两端对齐)。
ColumnLayout {
    width: 420

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline

        // ItemTitle/ItemDescription 自带 Layout.fillWidth → 自然把右侧元素挤到行尾(justify-between)。
        ItemHeader {
            ItemTitle { text: qsTr("Starter Plan") }
            Badge { text: qsTr("Popular") }
        }
        ItemContent {
            ItemDescription {
                text: qsTr("Everything you need to launch a small project and grow.")
            }
        }
        ItemFooter {
            ItemDescription { text: qsTr("$9 / month"); maximumLineCount: 1 }
            Button { text: qsTr("Upgrade"); size: Button.Sm }
        }
    }
}
