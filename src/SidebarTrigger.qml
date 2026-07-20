import QtQuick

// shadcn SidebarTrigger —— 切换 Sidebar 折叠/展开的按钮。
// = Button variant=ghost size=icon(size-7 → 28)+ panel-left 图标。
// 用法:设置 sidebar 指向目标 Sidebar,点击即翻转其 collapsed。
IconButton {
    id: control

    // 目标 Sidebar(需外部绑定)。
    property var sidebar: null

    variant: IconButton.Ghost
    size: IconButton.Medium          // 28 = size-7
    iconName: "panel-left"

    onClicked: if (sidebar) sidebar.collapsed = !sidebar.collapsed
}
