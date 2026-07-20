import QtQuick

// shadcn NavigationMenuItem(base-mira)—— 导航条中的单个项。两种形态:
//   1) 带下拉:设 text 作触发头(含 chevron),放入 NavigationMenuLink 子项作为下拉内容;
//   2) 纯链接:设 asLink:true,整项即一个可点链接(如官方 "Docs"),点击发 triggered()。
//
// hover 协调:进入触发头即请求本容器(parent = NavigationMenu)展开本项;在项间移动会即时切换。
// 离开触发头与面板后经 150ms 宽限计时关闭 —— 用以「桥接」触发头与面板之间 8px 的空隙
//(官方以 CSS ::before 伪元素补齐,这里简化为宽限计时,是刻意简化点)。
Item {
    id: item

    property string text: ""
    property bool asLink: false        // true = 纯链接项,无下拉
    property int columns: 1            // 下拉网格列数(components 示例用 2)
    property real contentWidth: 384    // 下拉面板宽度(w-96 默认)

    signal triggered()                 // 纯链接项或子链接点击后上抛

    // 默认内容槽:NavigationMenuLink 子项 → 下拉面板内部网格。
    default property alias content: panel.links

    readonly property bool _hasContent: !asLink
    readonly property var _menu: item.parent   // 所属 NavigationMenu(RowLayout)

    implicitWidth: trigger.implicitWidth
    implicitHeight: trigger.implicitHeight

    NavigationMenuTrigger {
        id: trigger
        text: item.text
        showChevron: item._hasContent
        open: item._menu && item._menu.openItem === item

        onEntered: {
            closeTimer.stop()
            if (item._hasContent && item._menu)
                item._menu.requestOpen(item)
        }
        onExited: closeTimer.restart()
        onClicked: {
            if (item.asLink) {
                item.triggered()
            } else if (item._menu) {
                if (item._menu.openItem === item)
                    item._menu.requestClose(item)
                else
                    item._menu.requestOpen(item)
            }
        }
    }

    NavigationMenuContent {
        id: panel
        parent: trigger
        columns: item.columns
        width: item.contentWidth

        // hover 面板时取消关闭;离开时启动宽限计时。
        onHoveredChanged: hovered ? closeTimer.stop() : closeTimer.restart()

        // 面板自身因 Esc / 点击外部关闭时,同步复位容器的 openItem。
        onClosed: if (item._menu && item._menu.openItem === item) item._menu.requestClose(item)
    }

    // 关闭宽限计时(桥接触发头↔面板的空隙)。
    Timer {
        id: closeTimer
        interval: 150
        onTriggered: if (item._menu) item._menu.requestClose(item)
    }

    // 依据容器的当前展开项驱动面板开合。
    Connections {
        target: item._menu
        function onOpenItemChanged() {
            if (!item._hasContent)
                return
            if (item._menu.openItem === item)
                panel.open()
            else
                panel.close()
        }
    }

    // 子链接点击后关闭整菜单(链接为静态声明,创建完成时一次性接线)。
    Component.onCompleted: {
        for (let i = 0; i < panel.links.length; ++i) {
            let obj = panel.links[i]
            if (obj && obj.triggered !== undefined)
                obj.triggered.connect(function() { if (item._menu) item._menu.closeAll() })
        }
    }
}
