import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn SidebarMenuButton —— 可点击菜单项:图标 + 文本。
// h-8、rounded(radius-sm+2px≈8)、p-2、gap-2、text-xs;
// hover/active → bg-sidebar-accent + text-sidebar-accent-foreground,active 时 font-medium。
// collapsible=icon(父 Sidebar.collapsed):size-8! p-2! —— 收成 32×32 方块,仅居中显示图标、
// 隐藏文本;hover 时用 Tooltip(side=right)显示原标签。
// 简化:size(sm/lg)/variant(outline)、menu-action 预留右内边距未实现。
Item {
    id: control

    property string text: ""
    property string iconName: ""
    property bool active: false
    signal clicked()

    // 向上查找父 Sidebar 的折叠状态(读取到根的 _isSidebarRoot 标记)。
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
    implicitHeight: 32                                   // h-8
    implicitWidth: collapsed ? 32 : row.implicitWidth + 16  // group-data-[collapsible=icon]:size-8!

    Behavior on implicitWidth {
        NumberAnimation { duration: 200; easing.type: Easing.Linear }
    }

    readonly property bool _hovered: hover.hovered
    readonly property color _fg: (control.active || control._hovered)
        ? Theme.sidebarAccentForeground
        : Theme.sidebarForeground

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusMd                           // calc(radius-sm + 2px) = 8
        color: (control.active || control._hovered) ? Theme.sidebarAccent : "transparent"
    }

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.leftMargin: 8                            // p-2
        anchors.rightMargin: 8
        spacing: control.collapsed ? 0 : 8               // gap-2

        LucideIcon {
            visible: control.iconName !== ""
            name: control.iconName
            size: 16                                     // [&_svg]:size-4
            color: control._fg
            Layout.preferredWidth: visible ? 16 : 0
            Layout.preferredHeight: 16
        }
        Text {
            id: label
            // 折叠态隐藏文字,仅留居中图标。
            visible: !control.collapsed && control.text !== ""
            Layout.fillWidth: !control.collapsed
            Layout.preferredWidth: control.collapsed ? 0 : label.implicitWidth
            text: control.text
            color: control._fg
            font.pixelSize: Theme.textXs
            font.weight: control.active ? Font.Medium : Font.Normal
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    HoverHandler { id: hover }
    TapHandler { onTapped: control.clicked() }

    // 折叠态 hover 用 Tooltip 显示标签(对标 SidebarMenuButton 的 tooltip)。
    Tooltip {
        text: control.text
        side: Tooltip.Right
        visible: control.collapsed && control._hovered && control.text !== ""
    }
}
