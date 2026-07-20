import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

// shadcn ChartTooltipContent(base-mira)—— 图表悬浮提示框。
// 对标 .cn-chart-tooltip:bg-background border-border/50 rounded-lg px-2.5 py-1.5
//   text-xs/relaxed shadow-xl gap-1.5 min-w-32。
// 结构:可选 label(font-medium)+ 若干行 [指示器][名称 muted]⟷[值 mono medium]。
// items:[{ color, label, value }];indicator:0 dot / 1 line / 2 dashed。
Item {
    id: tip

    enum Indicator { Dot, Line, Dashed }

    property string labelText: ""
    property bool showLabel: true
    property var items: []
    property int indicator: ChartTooltip.Dot

    readonly property real _padX: Theme.space2_5   // px-2.5 = 10
    readonly property real _padY: Theme.space1_5   // py-1.5 = 6

    implicitWidth: Math.max(128, box.implicitWidth)   // min-w-32
    implicitHeight: box.implicitHeight

    Rectangle {
        id: box
        width: tip.implicitWidth
        implicitWidth: content.implicitWidth + tip._padX * 2
        implicitHeight: content.implicitHeight + tip._padY * 2
        radius: Theme.radiusLg
        color: Theme.background
        border.width: 1
        border.color: Theme.alpha(Theme.border, 0.5)   // border-border/50

        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: Theme.alpha("#000000", Theme.dark ? 0.6 : 0.22)  // shadow-xl(近似)
            shadowBlur: 0.7
            shadowVerticalOffset: 8
        }

        ColumnLayout {
            id: content
            x: tip._padX
            y: tip._padY
            width: box.width - tip._padX * 2
            spacing: Theme.space1_5              // gap-1.5

            Text {
                visible: tip.showLabel && tip.labelText !== ""
                Layout.fillWidth: true
                text: tip.labelText
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                font.weight: Font.Medium
            }

            Repeater {
                model: tip.items
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    spacing: Theme.space2            // gap-2

                    // ---- 指示器 ----
                    Item {
                        Layout.alignment: tip.indicator === ChartTooltip.Dot ? Qt.AlignVCenter : Qt.AlignTop
                        Layout.topMargin: tip.indicator === ChartTooltip.Dot ? 0 : 2
                        implicitWidth: tip.indicator === ChartTooltip.Dot ? 10 : (tip.indicator === ChartTooltip.Line ? 4 : 10)
                        implicitHeight: tip.indicator === ChartTooltip.Dot ? 10 : 10

                        // dot / line:实心圆角块;dashed:空心描边方块
                        Rectangle {
                            anchors.fill: parent
                            radius: 2
                            visible: tip.indicator !== ChartTooltip.Dashed
                            color: modelData.color
                        }
                        Rectangle {
                            anchors.fill: parent
                            radius: 2
                            visible: tip.indicator === ChartTooltip.Dashed
                            color: "transparent"
                            border.width: 1.5
                            border.color: modelData.color
                        }
                    }

                    Text {
                        text: modelData.label !== undefined ? modelData.label : ""
                        color: Theme.mutedForeground
                        font.pixelSize: Theme.textXs
                    }
                    Item { Layout.fillWidth: true; implicitWidth: Theme.space3 }
                    Text {
                        text: modelData.value !== undefined ? modelData.value : ""
                        color: Theme.foreground
                        font.pixelSize: Theme.textXs
                        font.weight: Font.Medium
                        font.family: Theme.fontMono
                    }
                }
            }
        }
    }
}
