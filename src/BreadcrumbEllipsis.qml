import QtQuick
import LucideIcons

// shadcn BreadcrumbEllipsis —— 折叠省略号(= <span class="cn-breadcrumb-ellipsis">)。
// base-mira: size-4 容器 + [&>svg]:size-3.5。色随 list = muted-foreground。
Item {
    implicitWidth: 16                   // size-4
    implicitHeight: 16

    LucideIcon {
        anchors.centerIn: parent
        name: "ellipsis"
        size: 14                        // svg size-3.5
        color: Theme.mutedForeground
    }
}
