import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn ItemMedia —— Item 的前置媒体位:图标 / 图片 / 头像等。shrink-0、居中。
// variant=icon:内置 LucideIcon(iconName,size-4);variant=image:size-8 圆角裁剪盒
// (xs 场景 size-6),可直接给 source 或放自定义子项;default:透明,承载 Avatar 等子项。
Item {
    id: media

    enum Variant { Default, Icon, Image }

    property int variant: ItemMedia.Default
    property string iconName: ""       // variant=icon 便捷图标
    property url source                // variant=image 便捷图片
    property color iconColor: Theme.foreground

    // 由父 Item 注入:hostSize(0 default / 1 sm / 2 xs)、topShift(有描述时顶对齐下移)。
    property int hostSize: 0
    property bool topShift: false

    readonly property string itemSlot: "item-media"
    default property alias content: slot.data

    // image 盒边长:xs → size-6(24),其余 size-8(32)。
    readonly property int _imgBox: hostSize === 2 ? 24 : 32
    readonly property int _iconSize: 16   // svg size-4
    readonly property bool _isImage: variant === ItemMedia.Image
    readonly property bool _isIcon: variant === ItemMedia.Icon && iconName !== ""

    Layout.alignment: (topShift ? Qt.AlignTop : Qt.AlignVCenter) | Qt.AlignHCenter
    Layout.topMargin: topShift ? 2 : 0   // translate-y-0.5

    implicitWidth: _isImage ? _imgBox : _isIcon ? _iconSize : slot.implicitWidth
    implicitHeight: _isImage ? _imgBox : _isIcon ? _iconSize : slot.implicitHeight

    // image 变体:圆角裁剪盒,可用 source 或自定义子项(object-cover)。
    Rectangle {
        id: imageBox
        visible: media._isImage
        anchors.centerIn: parent
        width: media._imgBox
        height: media._imgBox
        radius: Theme.radiusSm
        color: "transparent"
        clip: true

        RoundedImage {
            anchors.fill: parent
            source: media.source
            radius: imageBox.radius
            visible: String(media.source) !== ""
        }
    }

    LucideIcon {
        visible: media._isIcon
        anchors.centerIn: parent
        name: media.iconName
        size: media._iconSize
        color: media.iconColor
    }

    // default 变体或自定义子项(Avatar、头像组等)。
    Item {
        id: slot
        anchors.centerIn: parent
        visible: !media._isImage && !media._isIcon && children.length > 0
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
