import QtQuick
import QtQuick.Layouts
import Shadcn

// Scroll Area —— 竖向滚动的标签列表(对齐官方 scroll-area-demo:h-72 w-48、50 个版本标签 + 分隔线)。
ScrollArea {
    id: area
    width: 192          // w-48
    height: 288         // h-72

    Column {
        width: area.availableWidth      // 匹配视口宽,避免多余的横向滚动
        padding: 16                     // p-4
        spacing: 8                      // 分隔线上下 my-2 之间距

        Text {
            text: "Tags"
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.Medium
            bottomPadding: 8            // 与 spacing 合计 mb-4(16)
        }

        Repeater {
            model: 50
            delegate: Column {
                required property int index
                width: parent.width - 32   // 减去父 Column 的 p-4
                spacing: 8                  // my-2 上侧

                Text {
                    text: "v1.2.0-beta." + (50 - index)
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm
                }
                Separator { width: parent.width }
            }
        }
    }
}
