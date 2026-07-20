import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Effects

// shadcn Hover Card —— 鼠标悬停触发的富内容浮层(对标 base-ui PreviewCard)。
// 用法同 Popover:作为触发元素的子项声明,悬停在触发元素上时按 delay 打开、移开后按
// closeDelay 关闭;鼠标移入卡片内会保持打开。视觉复用 Popover:
// rounded-lg + p-2.5 + ring-1 ring-foreground/10 + shadow-md + fade/zoom(见 .cn-hover-card-content)。
// 内容槽:直接把子项写进 HoverCard(默认属性 → 内部 Popup 的 contentData);
// 内部机件(悬停探测/计时器/Popup)以显式 data 赋值,不占用默认属性。
Item {
    id: control

    // 放置方向(对标 HoverCardContent side,默认 bottom)。
    enum Side { Top, Right, Bottom, Left }
    property int side: HoverCard.Side.Bottom
    // 水平/垂直对齐(对标 align),相对触发器。默认 center。
    enum Align { Start, Center, End }
    property int align: HoverCard.Align.Center
    // 与触发器的间距(sideOffset,默认 4)。
    property int sideOffset: 4

    // 打开/关闭延迟(对标 HoverCardTrigger delay / closeDelay)。
    property int delay: 600
    property int closeDelay: 300

    // 默认宽度 w-72 = 288;使用方可覆盖(示例中有 w-64)。
    property int cardWidth: 288

    // 供内容布局使用的可用宽度(= 宽度 − 左右内边距)。
    readonly property alias availableWidth: popup.availableWidth
    // 卡片是否已打开(只读)。
    readonly property alias opened: popup.opened
    // 内容槽 —— 用户写在 HoverCard{} 里的子项进入内部 Popup。
    default property alias content: popup.contentData

    // 铺满触发元素,作为悬停探测区域(不拦截点击,按钮等仍可正常交互)。
    anchors.fill: parent

    property bool _triggerHovered: false
    property bool _contentHovered: false

    function _sync() {
        if (control._triggerHovered || control._contentHovered) {
            closeTimer.stop()
            if (!popup.opened)
                openTimer.restart()
        } else {
            openTimer.stop()
            closeTimer.restart()
        }
    }

    // 内部机件显式挂到 data,避免落入默认内容属性。
    data: [
        // 悬停在触发元素(parent = control)上。
        HoverHandler {
            onHoveredChanged: {
                control._triggerHovered = hovered
                control._sync()
            }
        },
        Timer {
            id: openTimer
            interval: control.delay
            onTriggered: popup.open()
        },
        Timer {
            id: closeTimer
            interval: control.closeDelay
            onTriggered: if (!control._triggerHovered && !control._contentHovered) popup.close()
        },
        C.Popup {
            id: popup

            width: control.cardWidth
            padding: Theme.space2_5            // p-2.5
            font.pixelSize: Theme.textXs       // text-xs
            modal: false
            dim: false
            closePolicy: C.Popup.NoAutoClose   // 由悬停逻辑控制开合

            // 按 side + align 定位于触发器(control 铺满触发器,故 control.width/height 即触发器尺寸)。
            x: {
                switch (control.side) {
                case HoverCard.Side.Left: return -width - control.sideOffset
                case HoverCard.Side.Right: return control.width + control.sideOffset
                default: // Top / Bottom —— 水平 align
                    switch (control.align) {
                    case HoverCard.Align.Start: return 0
                    case HoverCard.Align.End: return control.width - width
                    default: return (control.width - width) / 2
                    }
                }
            }
            y: {
                switch (control.side) {
                case HoverCard.Side.Top: return -height - control.sideOffset
                case HoverCard.Side.Bottom: return control.height + control.sideOffset
                default: // Left / Right —— 垂直 align
                    switch (control.align) {
                    case HoverCard.Align.Start: return 0
                    case HoverCard.Align.End: return control.height - height
                    default: return (control.height - height) / 2
                    }
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

                // 鼠标移入卡片内保持打开。
                HoverHandler {
                    onHoveredChanged: {
                        control._contentHovered = hovered
                        control._sync()
                    }
                }
            }

            // 弹出动效:fade + zoom-95(对标 data-open:fade-in/zoom-in-95)。
            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durFast }
                NumberAnimation { property: "scale"; from: 0.95; to: 1; duration: Theme.durFast }
            }
            exit: Transition {
                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durFast }
                NumberAnimation { property: "scale"; from: 1; to: 0.95; duration: Theme.durFast }
            }
        }
    ]
}
