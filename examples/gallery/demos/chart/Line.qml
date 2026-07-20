import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

Card {
    width: 420

    CardHeader {
        CardTitle { text: "Line Chart" }
        CardDescription { text: "January - June 2024" }
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
            hideTooltipLabel: true
            xTickFormatter: function (v) { return String(v).substring(0, 3) }
            series: [ { key: "desktop", label: "Desktop", color: Theme.chart1 } ]
            chartData: [
                { month: "January",  desktop: 186 },
                { month: "February", desktop: 305 },
                { month: "March",    desktop: 237 },
                { month: "April",    desktop: 73  },
                { month: "May",      desktop: 209 },
                { month: "June",     desktop: 214 }
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
                    text: "Trending up by 5.2% this month"
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm
                    font.weight: Font.Medium
                }
                LucideIcon { name: "trending-up"; size: 16; color: Theme.foreground }
            }
            Text {
                text: "Showing total visitors for the last 6 months"
                color: Theme.mutedForeground
                font.pixelSize: Theme.textSm
            }
        }
    }
}
