import QtQuick
import QtQuick.Layouts

// shadcn SidebarGroupLabel —— 分组标题(muted 小字):h-8、px-2、text-xs、
// 颜色 sidebar-foreground/70。为可读性用 Medium 字重(CSS 仅设色/字号,见报告)。
// collapsible=icon(父 Sidebar.collapsed):group-data-[collapsible=icon]:-mt-8 opacity-0 ——
// 折叠时高度收 0 且淡出,按 transition-[margin,opacity] duration-200 ease-linear 过渡。
Item {
    id: control
    property string text: ""

    // 向上查找父 Sidebar 的折叠状态。
    property bool collapsed: {
        var p = parent
        while (p) {
            if (p._isSidebarRoot === true)
                return p.collapsed
            p = p.parent
        }
        return false
    }

    Layout.fillWidth: true
    implicitHeight: collapsed ? 0 : 32               // h-8 → -mt-8 收起
    opacity: collapsed ? 0 : 1
    clip: true

    Behavior on implicitHeight {
        NumberAnimation { duration: 200; easing.type: Easing.Linear }
    }
    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.Linear }
    }

    Text {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 8        // px-2
        anchors.rightMargin: 8
        height: 32
        text: control.text
        color: Theme.alpha(Theme.sidebarForeground, 0.7)
        font.pixelSize: Theme.textXs
        font.weight: Font.Medium
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
}
