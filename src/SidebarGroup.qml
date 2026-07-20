import QtQuick
import QtQuick.Layouts

// shadcn SidebarGroup —— 一个分组容器,px-2 py-1(左右 8 / 上下 4)。
// 简化:未单独实现 SidebarGroupContent(其仅是 w-full 包装),菜单直接放进本组。
Item {
    id: control
    default property alias content: inner.data

    Layout.fillWidth: true
    implicitHeight: inner.implicitHeight + 8    // py-1(上下各 4)

    ColumnLayout {
        id: inner
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 8                   // px-2
        anchors.rightMargin: 8
        anchors.topMargin: 4                    // py-1
        spacing: 0
    }
}
