import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Resizable(base-mira)—— 可拖拽分栏面板组,基于 QtQuick.Controls SplitView。
// 组合对齐官方 ResizablePanelGroup:直接把内容项作为子项声明,面板间自动插入手柄。
//   Resizable { Item { SplitView.preferredWidth: … } Item { SplitView.fillWidth: true } }
// 面板间手柄为 1px border 色分隔线(hover/拖拽时高亮为 ring 色);withHandle=true 时
// 手柄中央显示 bg-border 抓手小块(对齐 .cn-resizable-handle-icon:竖分隔 w1×h6、横分隔 w6×h1)。
// orientation 直接用 Qt.Horizontal / Qt.Vertical;framed 控制外框圆角+描边(嵌套内层可关)。
C.SplitView {
    id: control

    // 是否在所有手柄中央显示抓手小块(对齐 shadcn ResizableHandle 的 withHandle)。
    property bool withHandle: false
    // 外框:rounded-lg + 1px border(demo 用;嵌套内层设 false 以免双重描边)。
    property bool framed: true

    readonly property bool _horizontal: orientation === Qt.Horizontal
    // 手柄可抓取厚度:视觉分隔线仅 1px,其余为透明抓取区(与两侧面板同底,近乎不可见)。
    readonly property real _thickness: Theme.space2

    clip: true

    background: Rectangle {
        color: "transparent"
        radius: control.framed ? Theme.radiusLg : 0
        border.width: control.framed ? 1 : 0
        border.color: Theme.border
    }

    handle: Item {
        id: hnd
        implicitWidth: control._horizontal ? control._thickness : control.width
        implicitHeight: control._horizontal ? control.height : control._thickness

        readonly property bool active: C.SplitHandle.hovered || C.SplitHandle.pressed

        // 1px 分隔线(始终可见)。
        Rectangle {
            anchors.centerIn: parent
            width: control._horizontal ? 1 : parent.width
            height: control._horizontal ? parent.height : 1
            color: hnd.active ? Theme.ring : Theme.border
            Behavior on color { ColorAnimation { duration: Theme.durFast } }
        }

        // 可选抓手小块(bg-border,rounded-lg;竖分隔 4×24,横分隔 24×4)。
        Rectangle {
            visible: control.withHandle
            anchors.centerIn: parent
            width: control._horizontal ? Theme.space1 : Theme.space6
            height: control._horizontal ? Theme.space6 : Theme.space1
            radius: Theme.radiusLg
            color: hnd.active ? Theme.ring : Theme.border
            Behavior on color { ColorAnimation { duration: Theme.durFast } }
        }

        // 悬停显示分栏光标(不拦截按下,故不影响 SplitView 拖拽)。
        HoverHandler {
            cursorShape: control._horizontal ? Qt.SplitHCursor : Qt.SplitVCursor
        }
    }
}
