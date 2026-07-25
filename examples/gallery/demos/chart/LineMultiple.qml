import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

Card {
    width: 420

    CardHeader {
        CardTitle { text: qsTr("Line Chart - Multiple") }
        CardDescription { text: qsTr("January - June 2024") }
    }

    CardContent {
        Chart {
            Layout.fillWidth: true
            Layout.preferredHeight: 250
            type: Chart.Line
            categoryKey: "month"
            curved: true
            showGrid: true
            showXAxis: true
            showLegend: true
            xTickFormatter: function (v) { return String(v).substring(0, 3) }
            series: [
                { key: "desktop", label: qsTr("Desktop"), color: Theme.chart1 },
                { key: "mobile",  label: qsTr("Mobile"),  color: Theme.chart2 }
            ]
            chartData: [
                { month: "January",  desktop: 186, mobile: 80  },
                { month: "February", desktop: 305, mobile: 200 },
                { month: "March",    desktop: 237, mobile: 120 },
                { month: "April",    desktop: 73,  mobile: 190 },
                { month: "May",      desktop: 209, mobile: 130 },
                { month: "June",     desktop: 214, mobile: 140 }
            ]
        }
    }

    CardFooter {
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space2
            RowLayout {
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
                text: qsTr("Showing total visitors for the last 6 months")
                color: Theme.mutedForeground
                font.pixelSize: Theme.textSm
            }
        }
    }
}
