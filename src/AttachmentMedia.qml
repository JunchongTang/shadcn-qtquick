import QtQuick
import QtQuick.Layouts
import LucideIcons

/*!
    \qmltype AttachmentMedia
    \inqmlmodule Shadcn
    \inherits Item
    \brief The leading media slot of an \l Attachment: file icon or thumbnail.

    AttachmentMedia mirrors \c .cn-attachment-media: an aspect-square, center-cropped,
    bg-muted, rounded-md box. With \l variant \c Icon it shows a built-in
    \c LucideIcon (\l iconName), or you can supply a custom centered child such as
    a Spinner. With \l variant \c Image it shows a cover thumbnail from \l source
    (or a custom child), cropped to the box radius via \c RoundedImage.

    Box size, radius and icon size derive from the host \l {Attachment::size}{size}
    and \l {Attachment::orientation}{orientation}; the error state turns destructive.

    \sa Attachment, AttachmentContent
*/
Item {
    id: media

    // Content kind (documented on the variant property).
    enum Variant { Icon, Image }

    /*!
        \qmlproperty enumeration AttachmentMedia::variant
        Content kind. Defaults to \c AttachmentMedia.Icon.

        \value AttachmentMedia.Icon File-type icon or custom centered child (default).
        \value AttachmentMedia.Image Cover thumbnail cropped to the box radius.
    */
    property int variant: AttachmentMedia.Icon
    /*!
        \qmlproperty string AttachmentMedia::iconName
        Lucide icon name for the \c Icon variant.
    */
    property string iconName: ""
    /*!
        \qmlproperty url AttachmentMedia::source
        Thumbnail image URL for the \c Image variant.
    */
    property url source
    /*!
        \qmlproperty list<QtObject> AttachmentMedia::content
        Default slot for a custom centered child (e.g. a Spinner).
    */
    default property alias content: slot.data

    /*!
        \qmlproperty enumeration AttachmentMedia::hostSize
        Size injected by the parent \l Attachment. See \l {Attachment::size}.
    */
    property int hostSize: Attachment.Default
    /*!
        \qmlproperty enumeration AttachmentMedia::hostOrientation
        Orientation injected by the parent. See \l {Attachment::orientation}.
    */
    property int hostOrientation: Attachment.Horizontal
    /*!
        \qmlproperty enumeration AttachmentMedia::hostState
        Upload state injected by the parent. See \l {Attachment::uploadState}.
    */
    property int hostState: Attachment.Done

    /*!
        \qmlproperty string AttachmentMedia::attachSlot
        \readonly Slot marker used by Attachment routing.
    */
    readonly property string attachSlot: "attachment-media"

    readonly property bool _vertical: hostOrientation === Attachment.Vertical
    readonly property bool _error: hostState === Attachment.Error
    readonly property bool _isImage: variant === AttachmentMedia.Image

    // Square edge (horizontal): w-10 40 / w-8 32 / w-7 28; vertical: full width
    // (parent sets fillWidth).
    readonly property real _box: hostSize === Attachment.Sm ? 32
                               : hostSize === Attachment.Xs ? 28 : 40
    // Icon svg: default/sm size-4 (16), xs size-3.5 (14); vertical size-6 (24).
    readonly property int _iconSize: _vertical ? 24 : (hostSize === Attachment.Xs ? 14 : 16)
    // Image variant: opacity-60 unless idle/done.
    readonly property bool _dim: _isImage && hostState !== Attachment.Idle
                                          && hostState !== Attachment.Done

    implicitWidth: _box
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

        // Convenience cover image (variant=image + source), cropped to the box
        // radius (clip only crops a rectangle).
        RoundedImage {
            anchors.fill: parent
            source: media.source
            radius: box.radius
            visible: media._isImage && String(media.source) !== ""
        }

        // Convenience file-type icon (variant=icon + iconName).
        LucideIcon {
            anchors.centerIn: parent
            visible: !media._isImage && media.iconName !== "" && slot.children.length === 0
            name: media.iconName
            size: media._iconSize
            color: media._error ? Theme.destructive : Theme.foreground
        }

        // Custom child (e.g. Spinner): centered.
        Item {
            id: slot
            anchors.centerIn: parent
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }
}
