import QtQuick
import LucideIcons

// shadcn BreadcrumbSeparator —— 分隔符(= <li class="cn-breadcrumb-separator">,[&>svg]:size-3.5)。
// 默认 chevron-right;自定义分隔符改 iconName(如 "dot" 圆点)。色随 list = muted-foreground。
Item {
    id: root

    property string iconName: "chevron-right"

    implicitWidth: 14                   // svg size-3.5
    implicitHeight: 14

    LucideIcon {
        anchors.centerIn: parent
        name: root.iconName
        size: 14
        color: Theme.mutedForeground
    }
}
