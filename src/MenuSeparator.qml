import QtQuick
import QtQuick.Controls.Basic as C

// shadcn DropdownMenuSeparator:1px 分隔线(bg-border/50),上下留小间距(my-1)。
// 文件名 MenuSeparator 与基类同名 → 别名导入(as C)。
C.MenuSeparator {
    id: control

    padding: 0
    topPadding: Theme.space1         // my-1
    bottomPadding: Theme.space1

    contentItem: Rectangle {
        implicitHeight: 1            // h-px
        color: Theme.alpha(Theme.border, 0.5)  // bg-border/50
    }
}
