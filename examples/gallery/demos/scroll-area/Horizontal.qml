import QtQuick
import QtQuick.Layouts
import Shadcn

// Horizontal — horizontally scrolling image row (matches the Official scroll-area-horizontal-demo: w-96, a row of artwork thumbnails).
// No network images: use rounded placeholder blocks (chart token colors) to represent the artworks, with the artist credit below.
ScrollArea {
    id: area
    width: 384          // w-96
    height: 280

    readonly property var works: [
        { artist: "Ornella Binni",     tint: Theme.chart1 },
        { artist: "Tom Byrom",         tint: Theme.chart3 },
        { artist: "Vladimir Malyavko", tint: Theme.chart5 }
    ]

    Row {
        padding: 16         // p-4
        spacing: 16         // space-x-4

        Repeater {
            model: area.works
            delegate: Column {
                required property var modelData
                spacing: 8              // pt-2 gap between credit and image

                // Image placeholder (aspect-[3/4], rounded, clipped)
                Rectangle {
                    width: 150
                    height: 200         // 3:4
                    radius: Theme.radiusMd
                    color: modelData.tint
                    clip: true
                }

                Text {
                    width: 150
                    text: qsTr("Photo by ") + modelData.artist
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textXs
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}
