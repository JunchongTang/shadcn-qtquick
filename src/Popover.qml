import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Effects

// shadcn Popover —— 由按钮触发、在浮层中展示任意富内容。
// QtQuick.Controls 无 Popover 类型,基于 C.Popup 实现(Menu/Dialog 亦为 Popup 家族)。
// 面板样式对齐 .cn-popover-content:rounded-lg + p-2.5 + ring-1 ring-foreground/10 + shadow-md + fade/zoom。
// 内容槽:直接把子项写进 Popover(默认属性 contentData),会以 p-2.5 内边距布局。
C.Popup {
    id: control

    // 水平对齐(对标 base-ui PopoverContent align),相对触发器。默认 center。
    enum Align { Start, Center, End }
    property int align: Popover.Align.Center
    // 与触发器的间距(sideOffset,默认 4),向下弹出。
    property int sideOffset: 4

    // 默认宽度 w-72 = 288;使用方可覆盖 width(示例中有 w-80/w-64/w-40)。
    width: 288
    padding: Theme.space2_5            // p-2.5
    font.pixelSize: Theme.textXs       // text-xs
    modal: false
    dim: false
    closePolicy: C.Popup.CloseOnEscape | C.Popup.CloseOnPressOutside

    // 定位:默认在触发器(parent)下方,按 align 计算水平位置(origin 随 side=bottom)。
    y: (parent ? parent.height : 0) + sideOffset
    x: {
        if (!parent)
            return 0
        switch (align) {
        case Popover.Align.Start: return 0
        case Popover.Align.End: return parent.width - width
        default: return (parent.width - width) / 2
        }
    }

    // 弹出面 popover:rounded-lg + ring-1 ring-foreground/10 + shadow-md。
    background: Rectangle {
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
