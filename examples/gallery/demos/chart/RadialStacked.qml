import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

Card {
    width: 420

    CardHeader {
        Layout.alignment: Qt.AlignHCenter
        CardTitle {
            text: qsTr("Radial Chart - Stacked")
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
            Layout.preferredHeight: 200
            type: Chart.Radial
            stacked: true
            // 顶部半环(官方 endAngle=180):左→上→右扫 180°。
            radialStartDeg: -90
            radialEndDeg: 90
            innerRadius: 70
            outerRadius: 110
            radialCornerRadius: 5
            tooltipEnabled: false
            centerText: (1830).toLocaleString(Qt.locale("en_US"))
            centerSubtext: "Visitors"
            centerYOffset: -18
            series: [
                { key: "desktop", label: qsTr("Desktop"), color: Theme.chart1 },
                { key: "mobile",  label: qsTr("Mobile"),  color: Theme.chart2 }
            ]
            chartData: [
                { month: "january", desktop: 1260, mobile: 570 }
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
