import QtQuick
import QtQuick.Controls.Basic

// shadcn Tooltip —— 深底浅字(对标前端 bg-foreground text-background 反色)。
// 文件名 Tooltip 与基类 ToolTip 大小写不同,不冲突,无需别名导入。
ToolTip {
    id: control

    delay: 300
    font.pixelSize: Theme.textXs
    leftPadding: Theme.space3
    rightPadding: Theme.space3
    topPadding: Theme.space1_5
    bottomPadding: Theme.space1_5

    contentItem: Text {
        text: control.text
        font: control.font
        color: Theme.background            // 反色:深底上的浅字
        wrapMode: Text.Wrap
        maximumLineCount: 8
        // max-w-xs ≈ 20rem
        Component.onCompleted: if (implicitWidth > 320) width = 320
    }

    background: Rectangle {
        color: Theme.foreground
        radius: Theme.radiusMd
    }

    // fade-in / fade-out(对标 data-open:fade-in / data-closed:fade-out)
    enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durFast } }
    exit: Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durFast } }
}
