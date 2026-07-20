import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

// shadcn Tooltip —— 深底浅字(对标前端 bg-foreground text-background 反色)。
// 文件名 Tooltip 与基类 ToolTip 大小写不同,不冲突,无需别名导入。
ToolTip {
    id: control

    // 放置方向(对标 TooltipContent side,默认 top)。
    enum Side { Top, Right, Bottom, Left }
    property int side: Tooltip.Top
    // 触发元素与气泡之间的间距(对标 sideOffset)。
    property real sideOffset: Theme.space1_5
    // 可选键位提示(对标 <Kbd>);非空时在文本右侧追加胶囊。
    property string kbd: ""

    delay: 300
    font.pixelSize: Theme.textXs
    leftPadding: Theme.space3
    // has-data-[slot=kbd]:pr-1.5 —— 带 Kbd 时右内边距收窄。
    rightPadding: kbd !== "" ? Theme.space1_5 : Theme.space3
    topPadding: Theme.space1_5
    bottomPadding: Theme.space1_5

    // 相对触发元素(parent)按 side 定位。
    x: {
        switch (side) {
        case Tooltip.Left: return -width - sideOffset
        case Tooltip.Right: return parent ? parent.width + sideOffset : 0
        default: return parent ? (parent.width - width) / 2 : 0   // Top / Bottom
        }
    }
    y: {
        switch (side) {
        case Tooltip.Top: return -height - sideOffset
        case Tooltip.Bottom: return parent ? parent.height + sideOffset : 0
        default: return parent ? (parent.height - height) / 2 : 0  // Left / Right
        }
    }

    contentItem: RowLayout {
        spacing: Theme.space1_5                 // gap-1.5
        Text {
            Layout.maximumWidth: 320            // max-w-xs ≈ 20rem
            text: control.text
            font: control.font
            color: Theme.background             // 反色:深底上的浅字
            wrapMode: Text.Wrap
            maximumLineCount: 8
        }
        Kbd {
            visible: control.kbd !== ""
            text: control.kbd
        }
    }

    background: Rectangle {
        color: Theme.foreground
        radius: Theme.radiusMd
    }

    // fade-in / fade-out(对标 data-open:fade-in / data-closed:fade-out)
    enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durFast } }
    exit: Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durFast } }
}
