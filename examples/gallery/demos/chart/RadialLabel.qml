import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

Card {
    width: 420

    CardHeader {
        Layout.alignment: Qt.AlignHCenter
        CardTitle {
            text: qsTr("Radial Chart - Label")
            horizontalAlignment: Text.AlignHCenter
        }
        CardDescription {
            text: qsTr("January - June 2024")
            horizontalAlignment: Text.AlignHCenter
        }
    }

    CardContent {
        Chart {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 250
            Layout.preferredHeight: 250
            type: Chart.Radial
            nameKey: "browser"
            valueKey: "visitors"
            innerRadius: 30
            outerRadius: 110
            // 官方 startAngle=-90 endAngle=380(470° 轻微叠绕);此处裁剪到整圈。
            radialStartDeg: -90
            radialEndDeg: 270
            radialBackground: true
            showBarLabels: true                 // LabelList insideStart
            hideTooltipLabel: true
            chartData: [
                { browser: "chrome",  visitors: 275, color: Theme.chart1 },
                { browser: "safari",  visitors: 200, color: Theme.chart2 },
                { browser: "firefox", visitors: 187, color: Theme.chart3 },
                { browser: "edge",    visitors: 173, color: Theme.chart4 },
                { browser: "other",   visitors: 90,  color: Theme.chart5 }
            ]
        }
    }

    CardFooter {
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.space2
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.space2
                Text {
                    text: qsTr("Trending up by 5.2% this month")
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm
                    font.weight: Font.Medium
                }
                LucideIcon { name: "trending-up"; size: 16; color: Theme.foreground }
            }
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Showing total visitors for the last 6 months")
                color: Theme.mutedForeground
                font.pixelSize: Theme.textSm
            }
        }
    }
}
