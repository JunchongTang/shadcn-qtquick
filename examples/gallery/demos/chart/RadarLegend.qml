import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

Card {
    width: 420

    CardHeader {
        Layout.alignment: Qt.AlignHCenter
        CardTitle {
            text: "Radar Chart - Legend"
            horizontalAlignment: Text.AlignHCenter
        }
        CardDescription {
            text: "Showing total visitors for the last 6 months"
            horizontalAlignment: Text.AlignHCenter
        }
    }

    CardContent {
        Chart {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 250
            Layout.preferredHeight: 280
            type: Chart.Radar
            categoryKey: "month"
            showLegend: true
            tooltipIndicator: ChartTooltip.Line
            series: [
                { key: "desktop", label: "Desktop", color: Theme.chart1 },
                { key: "mobile",  label: "Mobile",  color: Theme.chart2 }
            ]
            chartData: [
                { month: "January",  desktop: 186, mobile: 80 },
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
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.space2
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
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
                Layout.alignment: Qt.AlignHCenter
                text: "January - June 2024"
                color: Theme.mutedForeground
                font.pixelSize: Theme.textSm
            }
        }
    }
}
