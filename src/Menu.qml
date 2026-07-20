import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Effects

// shadcn DropdownMenu 的弹出容器。文件名 Menu 与基类 Menu 同名 → 别名导入(as C),根用 C.Menu。
C.Menu {
    id: control

    padding: Theme.space1            // p-1
    font.pixelSize: Theme.textXs
    overlap: 0
    modal: false

    // C.Menu 不会自动按最宽项撑宽(其 ListView contentItem 不上报内容宽,菜单宽只取 background 的 min-w),
    // 故显式把 contentWidth 设为最宽项的 implicitWidth → 文本完整显示、不被省略。
    contentWidth: {
        var w = 0
        for (var i = 0; i < count; i++) {
            var it = itemAt(i)
            if (it && it.implicitWidth > w)
                w = it.implicitWidth
        }
        return w
    }

    // 子菜单触发项(嵌套 Menu)由本 delegate 自动创建 → 复用样式化 MenuItem(带右侧 chevron)。
    delegate: MenuItem {}

    // 弹出面 popover:rounded-lg + ring-1 ring-foreground/10 + shadow-md。
    background: Rectangle {
        implicitWidth: 128           // min-w-32 = 8rem
        color: Theme.popover
        radius: Theme.radiusLg
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: Theme.shadowColor
            shadowBlur: Theme.shadowBlur
            shadowVerticalOffset: Theme.shadowOffset
        }
    }

    // 弹出动效:fade + zoom-95(对标 data-open:fade-in/zoom-in-95)
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durFast }
        NumberAnimation { property: "scale"; from: 0.95; to: 1; duration: Theme.durFast }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durFast }
        NumberAnimation { property: "scale"; from: 1; to: 0.95; duration: Theme.durFast }
    }
}
