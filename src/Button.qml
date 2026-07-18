import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Button —— 无前缀,强类型枚举。
// 基类别名导入(as C),使文件自身类型名 Button 可用于枚举访问。
C.Button {
    id: control

    enum Variant { Default, Secondary, Outline, Ghost, Destructive, Link }
    enum Size { Small, Medium, Large, Icon }

    property int variant: Button.Default
    property int size: Button.Medium

    readonly property bool _icon: size === Button.Icon
    implicitHeight: size === Button.Small ? 24 : size === Button.Large ? 32 : 28
    implicitWidth: _icon ? implicitHeight
                         : Math.max(contentItem.implicitWidth + leftPadding + rightPadding, implicitHeight)

    padding: 0
    leftPadding: _icon ? 0 : Theme.space2
    rightPadding: _icon ? 0 : Theme.space2
    font.pixelSize: Theme.textXs
    font.weight: Font.Medium
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5

    readonly property color _fg: {
        switch (variant) {
        case Button.Default: return Theme.primaryForeground
        case Button.Secondary: return Theme.secondaryForeground
        case Button.Destructive: return Theme.destructive
        case Button.Link: return Theme.primary
        default: return Theme.foreground // Outline / Ghost
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        color: control._fg
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        radius: Theme.radiusMd
        border.width: control.variant === Button.Outline ? 1 : 0
        border.color: Theme.border
        color: {
            switch (control.variant) {
            case Button.Default:
                return control.down ? Theme.alpha(Theme.primary, 0.9)
                     : control.hovered ? Theme.alpha(Theme.primary, 0.8) : Theme.primary
            case Button.Secondary:
                return control.down || control.hovered ? Qt.darker(Theme.secondary, 1.08) : Theme.secondary
            case Button.Destructive:
                return Theme.alpha(Theme.destructive, control.hovered ? 0.2 : 0.1)
            case Button.Outline:
                return control.hovered ? Theme.alpha(Theme.muted, 0.6) : "transparent"
            case Button.Ghost:
                return control.down ? Theme.muted
                     : control.hovered ? Theme.alpha(Theme.muted, 0.7) : "transparent"
            default:
                return "transparent" // Link
            }
        }
        Behavior on color { ColorAnimation { duration: Theme.durFast } }
    }
}
