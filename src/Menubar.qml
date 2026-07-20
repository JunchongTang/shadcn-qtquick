import QtQuick

// shadcn Menubar(base-mira)—— 桌面应用式顶部菜单栏:横向一排 MenubarMenu。
// CSS: .cn-menubar { h-9 rounded-lg border p-1; flex items-center }。
// 无背景填充,仅 rounded-lg 边框 + p-1 内边距;子项为 MenubarMenu。
Item {
    id: control

    // 当前展开的 MenubarMenu(null=全收起),用于「悬停切换」联动。
    property Item openMenu: null

    // 默认子项(MenubarMenu)落入内部 Row。
    default property alias content: row.data

    implicitWidth: row.implicitWidth + Theme.space1 * 2   // p-1 两侧
    implicitHeight: 36                                     // h-9

    // rounded-lg border(透明填充)。
    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusLg
        color: "transparent"
        border.width: 1
        border.color: Theme.border
    }

    Row {
        id: row
        x: Theme.space1                 // p-1
        y: Theme.space1
        height: parent.height - Theme.space1 * 2
        spacing: Theme.space0_5         // 触发按钮间小间距
    }

    // 把自身注入每个 MenubarMenu.bar,建立联动。
    Component.onCompleted: {
        for (var i = 0; i < row.children.length; ++i) {
            var c = row.children[i]
            if (c && c.isMenubarMenu === true)
                c.bar = control
        }
    }
}
