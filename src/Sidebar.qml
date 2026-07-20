import QtQuick
import QtQuick.Layouts

// shadcn Sidebar 根容器 —— sidebar 底色 + 右边框,内部按 Header / Content / Footer 纵向堆叠。
// 展开时宽 16rem(256);collapsed=true 时收成图标条(3rem≈48,对标 collapsible=icon):
// 菜单按钮只显图标居中、分组标题隐去,宽度切换按 duration-200 ease-linear 平滑过渡。
// 子件通过向上查找本根的 _isSidebarRoot 标记读取 collapsed(无 Provider 上下文的简化实现)。
// 简化(见报告):移动端 sheet、offcanvas/floating/inset 变体、状态持久化未实现。
Rectangle {
    id: root

    // 直接把子项塞进纵向布局:Header / Content / Footer
    default property alias content: col.data

    // 折叠状态(向后兼容:默认 false = 展开,外观与原基础版一致)。
    property bool collapsed: false
    // 展开宽度(--sidebar-width 16rem)与图标条宽度(--sidebar-width-icon 3rem)。
    property int expandedWidth: 256
    property int iconWidth: 48
    // 子件向上查找用的标记(见 SidebarMenuButton / SidebarGroupLabel)。
    readonly property bool _isSidebarRoot: true

    implicitWidth: collapsed ? iconWidth : expandedWidth
    color: Theme.sidebar
    clip: true

    // .cn-sidebar-gap: transition-[width] duration-200 ease-linear
    Behavior on implicitWidth {
        NumberAnimation { duration: 200; easing.type: Easing.Linear }
    }

    ColumnLayout {
        id: col
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 1       // 不压到右边框
        spacing: 0
    }

    // border-r sidebar-border
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: Theme.sidebarBorder
    }
}
