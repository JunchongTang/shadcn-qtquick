import QtQuick
import QtQuick.Controls.Basic as C

// shadcn ScrollArea —— 带 rounded-md 边框的滚动容器 + 细滚动条。
// 权威(style-mira .cn-scroll-area · registry/bases/base ui/scroll-area):
//   scrollbar 竖向 w-2.5 / 横向 h-2.5(10px)、内缩 p-px;thumb bg-border、rounded-full。
//   容器用法 rounded-md border(见 scroll-area-demo)。
// 竖向 / 横向由内容尺寸自动决定:把「单个内容项」作为子节点放入,其宽/高决定可滚动范围。
// 与细滚动条 ScrollView 的区别:本组件多了圆角边框容器,且 thumb 用 border 而非 mutedForeground。
C.ScrollView {
    id: control

    clip: true

    // rounded-md border 容器(内容裁剪到矩形边界,圆角描边覆盖四角)
    background: Rectangle {
        radius: Theme.radiusMd          // rounded-md = 8
        color: "transparent"
        border.width: 1
        border.color: Theme.border
    }

    C.ScrollBar.vertical: C.ScrollBar {
        id: vbar
        parent: control
        anchors.top: control.top
        anchors.right: control.right
        anchors.bottom: control.bottom
        anchors.margins: 1              // p-px:贴合边框内缩 1px
        policy: C.ScrollBar.AsNeeded

        contentItem: Rectangle {
            implicitWidth: 10           // w-2.5
            radius: Theme.radiusFull    // rounded-full
            color: Theme.border         // bg-border
            opacity: vbar.active ? 1.0 : 0.0   // 空闲/无需滚动时淡出
            Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
        }
        background: Rectangle { color: "transparent" }
    }

    C.ScrollBar.horizontal: C.ScrollBar {
        id: hbar
        parent: control
        anchors.left: control.left
        anchors.right: control.right
        anchors.bottom: control.bottom
        anchors.margins: 1
        policy: C.ScrollBar.AsNeeded

        contentItem: Rectangle {
            implicitHeight: 10          // h-2.5
            radius: Theme.radiusFull    // rounded-full
            color: Theme.border         // bg-border
            opacity: hbar.active ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
        }
        background: Rectangle { color: "transparent" }
    }
}
