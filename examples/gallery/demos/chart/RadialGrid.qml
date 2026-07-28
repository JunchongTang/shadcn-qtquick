import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

Card {
    width: 420

    CardHeader {
        Layout.alignment: Qt.AlignHCenter
        CardTitle {
            text: qsTr("Radial Chart - Grid")
            horizontalAlignment: Text.AlignHCenter
        }
        CardDescription {
            text: qsTr("January - June 2024")
            horizontalAlignment: Text.AlignHCenter
        }
    }

    CardContent {
        Chart {
            Layout.fillWidth: true
            Layout.preferredHeight: 250
            type: Chart.Radial
            nameKey: "browser"
            valueKey: "visitors"
            innerRadius: 30
            outerRadius: 100
            polarGridCircle: true               // PolarGrid gridType="circle"
            hideTooltipLabel: true
            chartData: [
                { browser: "Chrome",  visitors: 275, color: Theme.chart1 },
                { browser: "Safari",  visitors: 200, color: Theme.chart2 },
                { browser: "Firefox", visitors: 187, color: Theme.chart3 },
                { browser: "Edge",    visitors: 173, color: Theme.chart4 },
                { browser: "Other",   visitors: 90,  color: Theme.chart5 }
            ]
        }
    }

    CardFooter {
        ColumnLayout {
            Layout.fillWidth: true
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
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Showing total visitors for the last 6 months")
                color: Theme.mutedForeground
                font.pixelSize: Theme.textSm
            }
        }
    }
}
