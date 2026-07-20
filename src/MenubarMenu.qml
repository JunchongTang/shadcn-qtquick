import QtQuick
import QtQuick.Controls.Basic as C

// shadcn MenubarMenu(base-mira)—— 一个「触发按钮 + 下拉 Menu」组合,放进 Menubar 一排里。
// 默认子项直接落入内部 Menu(复用 MenuItem/MenuSeparator/MenuLabel/MenuCheckboxItem/
// MenuRadioItem 及嵌套 Menu 子菜单),用法与独立 Menu 完全一致。
Item {
    id: mm

    property string title: ""                       // 触发按钮文字(File/Edit/…)
    property alias menuWidth: popup.implicitWidth    // 内容面板宽度(min-w-32=128)
    property Item bar: null                          // 由 Menubar 注入,做「联动切换」
    readonly property bool isMenubarMenu: true       // 供 Menubar 识别
    readonly property bool opened: popup.visible

    // 默认子项 → 内部 Menu。
    default property alias content: popup.contentData

    implicitWidth: trigger.implicitWidth
    height: parent ? parent.height : trigger.implicitHeight

    MenubarTrigger {
        id: trigger
        anchors.fill: parent
        text: mm.title
        open: popup.visible
        onClicked: mm.toggle()
        // 菜单栏联动:已有菜单展开时,悬停其它触发按钮即切换(桌面菜单栏惯例)。
        onHoveredChanged: {
            if (hovered && mm.bar && mm.bar.openMenu && mm.bar.openMenu !== mm)
                mm.openNow()
        }
    }

    // 下拉内容面板 —— 复用样式化 Menu(popover:rounded-lg + ring + shadow)。
    Menu {
        id: popup
        onClosed: if (mm.bar && mm.bar.openMenu === mm) mm.bar.openMenu = null
    }

    // sideOffset 8 / alignOffset -4(对齐 MenubarContent 默认)。
    function openNow() {
        if (mm.bar) {
            if (mm.bar.openMenu && mm.bar.openMenu !== mm)
                mm.bar.openMenu.close()
            mm.bar.openMenu = mm
        }
        popup.popup(trigger, -4, trigger.height + 8)
    }
    function close() { popup.close() }
    function toggle() { popup.visible ? popup.close() : openNow() }
}
