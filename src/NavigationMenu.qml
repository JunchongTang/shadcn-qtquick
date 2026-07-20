import QtQuick
import QtQuick.Layouts

// shadcn NavigationMenu(base-mira)—— 横向导航根容器。
// = <NavigationMenu> > <NavigationMenuList class="flex items-center justify-center">。
// base-mira: list 用 gap-0(项与项紧贴),max-w-max。直接放入 NavigationMenuItem 作为子项。
//
// 单一「打开项」模型:同一时刻至多一个 Item 展开下拉面板。各 Item 通过 parent 找到本容器,
// 调 requestOpen/requestClose 协调,hover 在项之间移动会即时切换(见 NavigationMenuItem)。
// 注:官方 viewport 的尺寸/位置补间(面板在不同项间平滑变形)做了简化 —— 这里每个 Item 各自
// 拥有独立 popover 面板,切换时旧面板淡出、新面板淡入,不做跨项形变动画。
RowLayout {
    id: root

    // 当前展开的 NavigationMenuItem(null 表示全部收起)。
    property var openItem: null

    spacing: 0   // gap-0

    // 供子 Item 调用的开合协调接口。
    function requestOpen(item) { root.openItem = item }
    function requestClose(item) { if (root.openItem === item) root.openItem = null }
    function closeAll() { root.openItem = null }
}
