import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 collapsible-settings —— 「Radius」设置卡:常驻两个输入框 + 右侧触发按钮
// (maximize/minimize 图标切换),展开后在下方揭示另外两个输入框。
Card {
    id: root
    width: 320
    size: Card.Small

    CardHeader {
        CardTitle { text: "Radius" }
        CardDescription { text: "Set the corner radius of the element." }
    }

    CardContent {
        Collapsible {
            id: c
            Layout.fillWidth: true
            gap: 8

            // ---- 常驻:首行两个输入框 + 触发按钮 ----
            trigger: RowLayout {
                width: parent.width
                spacing: 8
                Input { Layout.fillWidth: true; placeholderText: "0"; text: "0" }
                Input { Layout.fillWidth: true; placeholderText: "0"; text: "0" }
                Button {
                    variant: Button.Outline
                    size: Button.Icon
                    iconName: c.expanded ? "minimize" : "maximize"
                    onClicked: c.toggle()
                }
            }

            // ---- 可折叠:次行两个输入框(右侧预留按钮列以对齐)----
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Input { Layout.fillWidth: true; placeholderText: "0"; text: "0" }
                Input { Layout.fillWidth: true; placeholderText: "0"; text: "0" }
                Item { Layout.preferredWidth: 28 }
            }
        }
    }
}
