import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn EmptyMedia(base-mira) —— 空状态媒体槽(圆底图标 / 头像 / Spinner 等)。
// 对齐 .cn-empty-media:mb-2;items-center justify-center shrink-0。
//   default 变体:bg-transparent,尺寸随内容(用于头像 / 头像组)。
//   icon    变体:.cn-empty-media-icon —— bg-muted text-foreground size-8 rounded-md,内部 svg size-4。
// 便捷:icon 变体可直接设 iconName(Lucide 名);也可放入子件(如 Spinner)。
Item {
    id: control

    enum Variant { Default, Icon }
    property int variant: EmptyMedia.Default
    property string iconName: ""    // icon 变体便捷图标(Lucide 名)

    default property alias content: slot.data

    Layout.alignment: Qt.AlignHCenter
    Layout.bottomMargin: Theme.space2    // mb-2 = 8(叠加 header gap-1)

    readonly property bool _icon: variant === EmptyMedia.Icon
    implicitWidth: _icon ? 32 : slot.childrenRect.width      // size-8
    implicitHeight: _icon ? 32 : slot.childrenRect.height

    // icon 变体的圆底。
    Rectangle {
        anchors.fill: parent
        visible: control._icon
        radius: Theme.radiusMd           // rounded-md = 8
        color: Theme.muted               // bg-muted
    }

    // icon 变体便捷 Lucide 图标(svg size-4 = 16,text-foreground)。
    LucideIcon {
        anchors.centerIn: parent
        visible: control._icon && control.iconName !== ""
        name: control.iconName
        size: 16
        color: Theme.foreground
    }

    // 通用子件槽(头像 / 头像组 / Spinner),居中。
    Item {
        id: slot
        anchors.centerIn: parent
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
