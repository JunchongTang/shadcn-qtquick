import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn Badge(base-mira) —— h-5 胶囊(rounded-full)、text-[0.625rem]、6 变体。
// 支持前/后置图标(iconName/trailingIconName)、可选前/后置内容槽(leading/trailing,
// 用于放 Spinner 等),以及可覆盖配色(bgColor/fgColor/borderColor,默认按变体)。
Item {
    id: control

    enum Variant { Default, Secondary, Outline, Destructive, Ghost, Link }

    property int variant: Badge.Default
    property string text: ""
    property string iconName: ""          // 可选前置图标(svg size-2.5)
    property string trailingIconName: ""  // 可选后置图标

    // 前/后置内容槽(如 Spinner);color 用 fgColor 保持一致。
    property alias leading: leadingSlot.data
    property alias trailing: trailingSlot.data

    // 配色(默认按变体;可整体覆盖做自定义配色)。
    property color bgColor: {
        switch (variant) {
        case Badge.Default: return Theme.primary
        case Badge.Secondary: return Theme.secondary
        case Badge.Outline: return Theme.alpha(Theme.input, 0.2)              // bg-input/20
        case Badge.Destructive: return Theme.alpha(Theme.destructive, 0.1)   // bg-destructive/10
        default: return "transparent"  // Ghost / Link
        }
    }
    property color fgColor: {
        switch (variant) {
        case Badge.Default: return Theme.primaryForeground
        case Badge.Secondary: return Theme.secondaryForeground
        case Badge.Destructive: return Theme.destructive
        case Badge.Link: return Theme.primary
        default: return Theme.foreground  // Outline / Ghost
        }
    }
    property color borderColor: Theme.border

    // has-data-[icon=inline-start]:pl-1.5 / inline-end:pr-1.5,否则 px-2。
    readonly property bool _hasLeading: iconName !== "" || leadingSlot.children.length > 0
    readonly property bool _hasTrailing: trailingIconName !== "" || trailingSlot.children.length > 0
    readonly property real _padLeft: _hasLeading ? Theme.space1_5 : Theme.space2
    readonly property real _padRight: _hasTrailing ? Theme.space1_5 : Theme.space2

    implicitHeight: 20                    // h-5
    implicitWidth: _padLeft + row.implicitWidth + _padRight

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusFull                    // rounded-full 胶囊
        color: control.bgColor
        border.width: control.variant === Badge.Outline ? 1 : 0
        border.color: control.borderColor           // border-border
    }

    RowLayout {
        id: row
        anchors.left: parent.left
        anchors.leftMargin: control._padLeft
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.space1                        // gap-1

        Item {
            id: leadingSlot
            visible: children.length > 0
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
        LucideIcon {
            visible: control.iconName !== ""
            name: control.iconName
            size: 10                                 // svg size-2.5
            color: control.fgColor
        }
        Text {
            visible: control.text !== ""
            text: control.text
            color: control.fgColor
            font.pixelSize: 10                       // text-[0.625rem]
            font.weight: Font.Medium
            font.underline: control.variant === Badge.Link
        }
        LucideIcon {
            visible: control.trailingIconName !== ""
            name: control.trailingIconName
            size: 10
            color: control.fgColor
        }
        Item {
            id: trailingSlot
            visible: children.length > 0
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }
}
