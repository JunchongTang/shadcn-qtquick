import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

Card {
    width: 420

    CardHeader {
        Layout.alignment: Qt.AlignHCenter
        CardTitle {
            text: qsTr("Radial Chart - Text")
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
            valueKey: "visitors"
            nameKey: "browser"
            radialStartDeg: 0
            radialEndDeg: 250
            innerRadius: 80
            outerRadius: 90
            radialBackground: true
            radialCornerRadius: 10
            tooltipEnabled: false
            centerText: (200).toLocaleString(Qt.locale("en_US"))
            centerSubtext: "Visitors"
            chartData: [
                { browser: "safari", visitors: 200, color: Theme.chart2 }
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
