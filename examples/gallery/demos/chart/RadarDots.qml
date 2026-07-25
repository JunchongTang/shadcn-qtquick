import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

Card {
    width: 420

    CardHeader {
        Layout.alignment: Qt.AlignHCenter
        CardTitle {
            text: qsTr("Radar Chart - Dots")
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
            showDots: true
            series: [ { key: "desktop", label: qsTr("Desktop"), color: Theme.chart1 } ]
            chartData: [
                { month: "January",  desktop: 186 },
                { month: "February", desktop: 305 },
                { month: "March",    desktop: 237 },
                { month: "April",    desktop: 273 },
                { month: "May",      desktop: 209 },
                { month: "June",     desktop: 214 }
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
