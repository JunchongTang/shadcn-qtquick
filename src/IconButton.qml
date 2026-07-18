import QtQuick
import QtQuick.Controls.Basic as C
import LucideIcons

// shadcn 图标按钮(size=icon 的方形按钮 + Lucide 图标)。
C.Button {
    id: control

    enum Variant { Default, Secondary, Outline, Ghost, Destructive }
    enum Size { Small, Medium, Large }

    property int variant: IconButton.Ghost
    property int size: IconButton.Medium
    property string iconName: "" // Button.icon 是 FINAL,不能同名

    implicitHeight: size === IconButton.Small ? 24 : size === IconButton.Large ? 32 : 28
    implicitWidth: implicitHeight
    padding: 0
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5

    readonly property color _fg: {
        switch (variant) {
        case IconButton.Default: return Theme.primaryForeground
        case IconButton.Destructive: return Theme.destructive
        default: return Theme.mutedForeground
        }
    }

    contentItem: LucideIcon {
        name: control.iconName
        size: control.size === IconButton.Large ? 18 : 15
        color: control._fg
    }

    background: Rectangle {
        radius: Theme.radiusMd
        border.width: control.variant === IconButton.Outline ? 1 : 0
        border.color: Theme.border
        color: {
            switch (control.variant) {
            case IconButton.Default:
                return control.down ? Theme.alpha(Theme.primary, 0.9)
                     : control.hovered ? Theme.alpha(Theme.primary, 0.8) : Theme.primary
            case IconButton.Secondary:
                return control.down || control.hovered ? Qt.darker(Theme.secondary, 1.08) : Theme.secondary
            case IconButton.Destructive:
                return Theme.alpha(Theme.destructive, control.hovered ? 0.2 : 0.1)
            case IconButton.Outline:
                return control.hovered ? Theme.alpha(Theme.muted, 0.6) : "transparent"
            default: // Ghost
                return control.down ? Theme.muted
                     : control.hovered ? Theme.alpha(Theme.muted, 0.7) : "transparent"
            }
        }
        Behavior on color { ColorAnimation { duration: Theme.durFast } }
    }
}
