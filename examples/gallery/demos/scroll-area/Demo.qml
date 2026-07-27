import QtQuick
import QtQuick.Layouts
import Shadcn

// Scroll Area — vertically scrolling tag list (matches the Official scroll-area-demo: h-72 w-48, 50 version tags + dividers).
ScrollArea {
    id: area
    width: 192          // w-48
    height: 288         // h-72

    Column {
        width: area.availableWidth      // match viewport width to avoid extra horizontal scroll
        padding: 16                     // p-4
        spacing: 8                      // my-2 gap above/below each divider

        Text {
            text: qsTr("Tags")
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.Medium
            bottomPadding: 8            // together with spacing totals mb-4 (16)
        }

        Repeater {
            model: 50
            delegate: Column {
                required property int index
                width: parent.width - 32   // subtract the parent Column's p-4
                spacing: 8                  // my-2 top side

                Text {
                    text: qsTr("v1.2.0-beta.") + (50 - index)
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm
                }
                Separator { width: parent.width }
            }
        }
    }
}
