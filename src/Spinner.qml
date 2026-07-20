import QtQuick
import LucideIcons

// shadcn Spinner —— Loader2 图标 + 匀速旋转(animate-spin)。size/color 可直接设(继承 LucideIcon)。
LucideIcon {
    id: control
    name: "loader-2"
    size: 16                       // size-4
    color: Theme.foreground        // 默认前景色,调用方可覆盖(如按钮内设 primaryForeground)

    NumberAnimation on rotation {
        from: 0; to: 360
        duration: 800
        loops: Animation.Infinite
        running: control.visible
    }
}
