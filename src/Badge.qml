import QtQuick

// shadcn Badge —— 强类型枚举 variant。
Item {
    id: control

    enum Variant { Default, Secondary, Outline, Destructive }

    property int variant: Badge.Default
    property string text: ""

    implicitWidth: label.implicitWidth + 16
    implicitHeight: 18

    readonly property color _bg: {
        switch (variant) {
        case Badge.Default: return Theme.primary
        case Badge.Secondary: return Theme.secondary
        case Badge.Destructive: return Theme.destructive
        default: return "transparent" // Outline
        }
    }
    readonly property color _fg: {
        switch (variant) {
        case Badge.Default: return Theme.primaryForeground
        case Badge.Secondary: return Theme.secondaryForeground
        case Badge.Destructive: return "#ffffff"
        default: return Theme.foreground
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusSm
        color: control._bg
        border.width: control.variant === Badge.Outline ? 1 : 0
        border.color: Theme.border
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: control.text
        color: control._fg
        font.pixelSize: 11
        font.weight: Font.Medium
    }
}
