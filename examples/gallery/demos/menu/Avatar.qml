import QtQuick
// 本文件名为 Avatar.qml,与 Shadcn 的 Avatar 同名 → 用命名空间导入 S. 消除「同目录自引用」递归。
import Shadcn as S

// 头像触发的账户切换菜单(DropdownMenuTrigger render=ghost icon rounded-full + Avatar;align=end)。
S.Avatar {
    id: trigger
    fallback: "LR"
    source: "https://github.com/shadcn.png"

    // align=end:菜单右缘对齐头像右缘(用常量宽度,避免 popup 时 width 尚未求值)
    TapHandler { onTapped: menu.popup(trigger.width - menu._w, trigger.height + 4) }

    S.Menu {
        id: menu
        readonly property int _w: 180
        implicitWidth: _w

        S.MenuItem { text: "Account"; iconName: "badge-check" }
        S.MenuItem { text: "Billing"; iconName: "credit-card" }
        S.MenuItem { text: "Notifications"; iconName: "bell" }
        S.MenuSeparator {}
        S.MenuItem { text: "Sign Out"; iconName: "log-out" }
    }
}
