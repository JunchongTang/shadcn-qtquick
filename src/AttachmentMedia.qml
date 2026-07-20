import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn AttachmentMedia —— 附件媒体位:图标(文件类型)或图片缩略。
// 对标 .cn-attachment-media:aspect-square、居中裁剪、bg-muted、rounded-md。
// variant=icon:内置 LucideIcon(iconName),也可放自定义子项如 Spinner;
// variant=image:填满的封面图(source 或自定义 <img> 子项),object-cover。
// 尺寸/圆角/图标大小随宿主 size、orientation 派生;error 态转 destructive 处理。
Item {
    id: media

    enum Variant { Icon, Image }

    property int variant: AttachmentMedia.Icon
    property string iconName: ""
    property url source
    default property alias content: slot.data

    // 由父 Attachment 注入。
    property int hostSize: Attachment.Default
    property int hostOrientation: Attachment.Horizontal
    property int hostState: Attachment.Done

    readonly property string attachSlot: "attachment-media"

    readonly property bool _vertical: hostOrientation === Attachment.Vertical
    readonly property bool _error: hostState === Attachment.Error
    readonly property bool _isImage: variant === AttachmentMedia.Image

    // 方形边长(水平):w-10 40 / w-8 32 / w-7 28;垂直:整宽(由父设 fillWidth)。
    readonly property real _box: hostSize === Attachment.Sm ? 32
                               : hostSize === Attachment.Xs ? 28 : 40
    // 图标 svg:默认/sm size-4(16)、xs size-3.5(14);垂直 size-6(24)。
    readonly property int _iconSize: _vertical ? 24 : (hostSize === Attachment.Xs ? 14 : 16)
    // 图片变体:非 idle/done 时 opacity-60。
    readonly property bool _dim: _isImage && hostState !== Attachment.Idle
                                          && hostState !== Attachment.Done

    implicitWidth: _vertical ? _box : _box
    implicitHeight: _box

    Layout.preferredWidth: _vertical ? -1 : _box
    Layout.preferredHeight: _vertical ? -1 : _box

    Rectangle {
        id: box
        anchors.fill: parent
        radius: media.hostSize === Attachment.Xs ? Theme.radiusSm : Theme.radiusMd
        clip: true
        color: media._error ? Theme.alpha(Theme.destructive, 0.10) : Theme.muted
        opacity: media._dim ? 0.6 : 1.0
        Behavior on opacity { NumberAnimation { duration: Theme.durBase } }

        // 便捷封面图(variant=image + source)。按盒子圆角真正裁剪(clip 只裁矩形)。
        RoundedImage {
            anchors.fill: parent
            source: media.source
            radius: box.radius
            visible: media._isImage && String(media.source) !== ""
        }

        // 便捷文件类型图标(variant=icon + iconName)。
        LucideIcon {
            anchors.centerIn: parent
            visible: !media._isImage && media.iconName !== "" && slot.children.length === 0
            name: media.iconName
            size: media._iconSize
            color: media._error ? Theme.destructive : Theme.foreground
        }

        // 自定义子项(如 Spinner):居中。
        Item {
            id: slot
            anchors.centerIn: parent
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }
}
