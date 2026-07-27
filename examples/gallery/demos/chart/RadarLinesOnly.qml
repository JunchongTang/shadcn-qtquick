import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

Card {
    width: 420

    CardHeader {
        Layout.alignment: Qt.AlignHCenter
        CardTitle {
            text: qsTr("Radar Chart - Lines Only")
            horizontalAlignment: Text.AlignHCenter
        }
        CardDescription {
            text: qsTr("Showing total visitors for the last 6 months")
            horizontalAlignment: Text.AlignHCenter
        }
    }

    CardContent {
        Chart {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 250
            Layout.preferredHeight: 250
            type: Chart.Radar
            categoryKey: "month"
            radarFillOpacity: 0                 // stroke only
            polarRadialLines: false             // radialLines={false}
            tooltipIndicator: ChartTooltip.Line
            series: [
                { key: "desktop", label: qsTr("Desktop"), color: Theme.chart1 },
                { key: "mobile",  label: qsTr("Mobile"),  color: Theme.chart2 }
            ]
            chartData: [
                { month: "January",  desktop: 186, mobile: 160 },
                { month: "February", desktop: 185, mobile: 170 },
                { month: "March",    desktop: 207, mobile: 180 },
                { month: "April",    desktop: 173, mobile: 160 },
                { month: "May",      desktop: 160, mobile: 190 },
                { month: "June",     desktop: 174, mobile: 204 }
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
                text: qsTr("January - June 2024")
                color: Theme.mutedForeground
                font.pixelSize: Theme.textSm
            }
        }
    }
}
