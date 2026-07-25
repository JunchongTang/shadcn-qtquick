import QtQuick
import QtQuick.Layouts
import LucideIcons

/*!
    \qmltype ItemMedia
    \inqmlmodule Shadcn
    \inherits Item
    \brief Leading media slot of a \l ShadItem: icon, image or avatar.

    Shrinks to fit (shrink-0) and centres its content. The \c icon variant
    renders a built-in \l LucideIcon (\l iconName, size-4). The \c image variant
    is a rounded clipping box (size-8, or size-6 at host size xs) that shows the
    convenience \l source, or custom children when no source is set. The
    \c default variant is transparent and hosts arbitrary children such as an
    Avatar.

    When the parent \l ShadItem contains a description, media is top-aligned and
    nudged down 0.5 (2px) via \l topShift.
*/
Item {
    id: media

    enum Variant { Default, Icon, Image }

    /*!
        \qmlproperty int ItemMedia::variant
        Media kind. One of:
        \value ItemMedia.Default Transparent host for custom children.
        \value ItemMedia.Icon    Built-in Lucide icon from \l iconName.
        \value ItemMedia.Image   Rounded, clipped image box.
    */
    property int variant: ItemMedia.Default
    /*!
        \qmlproperty string ItemMedia::iconName
        Lucide icon name used by the \c icon variant.
    */
    property string iconName: ""       // convenience icon for variant=icon
    /*!
        \qmlproperty url ItemMedia::source
        Convenience image source used by the \c image variant.
    */
    property url source                // convenience image for variant=image
    /*!
        \qmlproperty color ItemMedia::iconColor
        Colour of the \c icon variant glyph.
    */
    property color iconColor: Theme.foreground

    /*!
        \qmlproperty int ItemMedia::hostSize
        Injected by the parent \l ShadItem (0 default / 1 sm / 2 xs); selects the
        image box side length.
    */
    // Injected by the parent ShadItem: hostSize (0 default / 1 sm / 2 xs) and
    // topShift (top-align when the item has a description).
    property int hostSize: 0
    /*!
        \qmlproperty bool ItemMedia::topShift
        Injected by the parent: when true (item has a description) the media
        top-aligns and shifts down 2px.
    */
    property bool topShift: false

    readonly property string itemSlot: "item-media"
    default property alias content: slot.data

    // Image box side: xs -> size-6 (24), otherwise size-8 (32).
    readonly property int _imgBox: hostSize === 2 ? 24 : 32
    readonly property int _iconSize: 16   // svg size-4
    readonly property bool _isImage: variant === ItemMedia.Image
    readonly property bool _isIcon: variant === ItemMedia.Icon && iconName !== ""

    Layout.alignment: (topShift ? Qt.AlignTop : Qt.AlignVCenter) | Qt.AlignHCenter
    Layout.topMargin: topShift ? 2 : 0   // translate-y-0.5

    implicitWidth: _isImage ? _imgBox : _isIcon ? _iconSize : slot.implicitWidth
    implicitHeight: _isImage ? _imgBox : _isIcon ? _iconSize : slot.implicitHeight

    // image variant: rounded clipping box driven by source or custom children.
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

    // default variant or custom children (Avatar, avatar stacks, etc.).
    Item {
        id: slot
        anchors.centerIn: parent
        visible: !media._isImage && !media._isIcon && children.length > 0
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
