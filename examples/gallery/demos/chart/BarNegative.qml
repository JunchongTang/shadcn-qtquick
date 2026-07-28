import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Bar chart with negative values: bars extend below a zero baseline and are
// coloured by sign. Ported from shadcn/ui chart-bar-negative.
Card {
    width: 420

    CardHeader {
        CardTitle { text: qsTr("Bar Chart - Negative") }
        CardDescription { text: qsTr("January - June 2024") }
    }

    CardContent {
        Chart {
            Layout.fillWidth: true
            Layout.preferredHeight: 250
            type: Chart.Bar
            categoryKey: "month"
            barRadius: 4
            showGrid: false
            showXAxis: false
            hideTooltipLabel: true
            tooltipCursor: false
            negativeColor: Theme.chart2
            series: [ { key: "visitors", label: qsTr("Visitors"), color: Theme.chart1 } ]
            chartData: [
                { month: "January",  visitors: 186  },
                { month: "February", visitors: 205  },
                { month: "March",    visitors: -207 },
                { month: "April",    visitors: 173  },
                { month: "May",      visitors: -209 },
                { month: "June",     visitors: 214  }
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
