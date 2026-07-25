import QtQuick
import QtQuick.Layouts
import Shadcn

// Horizontal —— 横向滚动的图片行(对齐官方 scroll-area-horizontal-demo:w-96、一排作品缩略图)。
// 无网络图片:以圆角占位块(chart 令牌色)代表画作,下方作者署名。
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
                spacing: 8              // pt-2 署名与图片间距

                // 图片占位(aspect-[3/4],圆角、裁剪)
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
