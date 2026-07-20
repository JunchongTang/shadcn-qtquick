import QtQuick

// shadcn SidebarRail —— 贴在 Sidebar 边缘的窄条(w-4 = 16),点击切换折叠。
// hover 时中缝显现 2px sidebar-border 线(after:w-[2px] hover:after:bg-sidebar-border)。
// 用法:置于 Sidebar 右边缘之上(自行 anchors 定位),绑定 sidebar 指向目标 Sidebar。
// 简化(见报告):不做拖拽调宽,仅点击切换;RTL 定位镜像跳过。
Item {
    id: control

    // 目标 Sidebar(需外部绑定)。
    property var sidebar: null

    implicitWidth: 16                // w-4

    // 中缝竖线:hover 显现,ease-linear 过渡。
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 2
        color: hover.hovered ? Theme.sidebarBorder : Theme.alpha(Theme.sidebarBorder, 0)
        Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.Linear }
        }
    }

    HoverHandler {
        id: hover
        cursorShape: Qt.SplitHCursor     // in-data-[side=left]:cursor-w-resize
    }
    TapHandler {
        onTapped: if (control.sidebar) control.sidebar.collapsed = !control.sidebar.collapsed
    }
}
