import QtQuick
import QtQuick.Controls.Basic as C

// shadcn ScrollView —— 文件名与基类同名(ScrollView),必须别名导入并以 C.ScrollView 为根。
// 细滚动条:轨道透明、滑块 mutedForeground/40(hover→60、pressed→70)、宽 ~8、radiusSm,
// 不需要时淡出。内容行为保持默认。
C.ScrollView {
    id: control

    C.ScrollBar.vertical: C.ScrollBar {
        id: vbar
        parent: control
        anchors.top: control.top
        anchors.right: control.right
        anchors.bottom: control.bottom
        policy: C.ScrollBar.AsNeeded

        contentItem: Rectangle {
            implicitWidth: 8
            radius: Theme.radiusSm
            color: vbar.pressed ? Theme.alpha(Theme.mutedForeground, 0.7)
                 : vbar.hovered ? Theme.alpha(Theme.mutedForeground, 0.6)
                                : Theme.alpha(Theme.mutedForeground, 0.4)
            opacity: vbar.active ? 1.0 : 0.0   // 空闲/不需要时淡出
            Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
            Behavior on color { ColorAnimation { duration: Theme.durFast } }
        }
        background: Rectangle { color: "transparent" }
    }

    C.ScrollBar.horizontal: C.ScrollBar {
        id: hbar
        parent: control
        anchors.left: control.left
        anchors.right: control.right
        anchors.bottom: control.bottom
        policy: C.ScrollBar.AsNeeded

        contentItem: Rectangle {
            implicitHeight: 8
            radius: Theme.radiusSm
            color: hbar.pressed ? Theme.alpha(Theme.mutedForeground, 0.7)
                 : hbar.hovered ? Theme.alpha(Theme.mutedForeground, 0.6)
                                : Theme.alpha(Theme.mutedForeground, 0.4)
            opacity: hbar.active ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
            Behavior on color { ColorAnimation { duration: Theme.durFast } }
        }
        background: Rectangle { color: "transparent" }
    }
}
