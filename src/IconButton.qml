import QtQuick
import QtQuick.Controls.Basic as C
import LucideIcons

// shadcn 图标按钮(= Button size=icon 的方形按钮 + Lucide 图标)。
// 变体/状态与 Button 对齐 base-mira;尺寸对应 icon-sm/icon/icon-lg(24/28/32)。
C.Button {
    id: control

    enum Variant { Default, Secondary, Outline, Ghost, Destructive }
    enum Size { Small, Medium, Large }

    property int variant: IconButton.Ghost
    property int size: IconButton.Medium
    property string iconName: "" // Button.icon 是 FINAL,不能同名

    // icon-sm 24 / icon 28 / icon-lg 32;svg 12 / 14 / 16。
    implicitHeight: size === IconButton.Small ? 24 : size === IconButton.Large ? 32 : 28
    implicitWidth: implicitHeight
    readonly property int _iconSize: size === IconButton.Small ? 12 : size === IconButton.Large ? 16 : 14
    padding: 0
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // 点击夺焦(对标 web);环用 visualFocus 门控,鼠标点击不显环
    opacity: enabled ? 1.0 : 0.5

    readonly property color _fg: {
        switch (variant) {
        case IconButton.Default: return Theme.primaryForeground
        case IconButton.Secondary: return Theme.secondaryForeground
        case IconButton.Destructive: return Theme.destructive
        default: return Theme.foreground   // Outline / Ghost
        }
    }

    contentItem: Item {
        transform: Translate { y: control.down ? 1 : 0 }   // active:translate-y-px
        LucideIcon {
            anchors.centerIn: parent
            name: control.iconName
            size: control._iconSize
            color: control._fg
        }
    }

    background: Rectangle {
        radius: Theme.radiusMd
        border.width: control.variant === IconButton.Outline ? 1 : 0
        border.color: Theme.border
        transform: Translate { y: control.down ? 1 : 0 }
        color: {
            switch (control.variant) {
            case IconButton.Default:
                return control.hovered ? Theme.alpha(Theme.primary, 0.8) : Theme.primary
            case IconButton.Secondary:
                return control.hovered ? Qt.darker(Theme.secondary, 1.05) : Theme.secondary
            case IconButton.Destructive:
                return Theme.alpha(Theme.destructive, control.hovered ? 0.2 : 0.1)
            case IconButton.Outline:
                return control.hovered ? Theme.alpha(Theme.input, 0.5) : Theme.alpha(Theme.input, 0)
            default: // Ghost
                return control.hovered ? Theme.muted : Theme.alpha(Theme.muted, 0)
            }
        }
        Behavior on color { ColorAnimation { duration: Theme.durBase } }

        FocusRing { active: control.visualFocus; targetRadius: Theme.radiusMd }
    }
}
