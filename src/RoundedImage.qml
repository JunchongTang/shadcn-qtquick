import QtQuick
import QtQuick.Effects

/*!
    \qmltype RoundedImage
    \inqmlmodule Shadcn
    \inherits Item
    \brief Displays an image that is genuinely clipped to rounded (or circular) corners.

    RoundedImage is an internal utility that crops an \l Image to a rounded-corner
    (or fully circular) shape. It exists because neither \c Image nor \c Rectangle
    \c clip can round corners: \c clip only cuts to the rectangular bounds, so the
    image keeps square corners regardless of any \c radius. It backs Avatar,
    AttachmentMedia, ItemMedia and MessageContent.

    \section2 Technique: offscreen layer + MultiEffect mask

    Two invisible offscreen textures are combined by a \l MultiEffect:

    \list
        \li The \b source \l Image sets \c {layer.enabled: true}. Rendering it into
            its own layer (an FBO) bakes the \l fillMode crop into a texture, so the
            effect masks the \e cropped result rather than the raw, uncropped pixmap.
            The image is \c {visible: false} so only the masked output is composited,
            never the raw image (see \l MultiEffect, which renders a new item beside
            the source). The layer stays a texture provider while hidden.
        \li The \b mask is a layered \l Item whose child \l Rectangle is filled opaque
            with the desired \l radius. MultiEffect masks by the mask's \e alpha
            channel: inside the rounded rectangle alpha is 1 (kept), outside it is 0
            (the transparent corners are cut away). The rounded edge is antialiased,
            giving a smooth clip.
    \endlist

    The MultiEffect overlays the source at the same position and shows only once the
    image reaches \c Image.Ready, so nothing flashes while loading.

    \section2 Circular cropping

    A \l Rectangle radius is clamped to \c {min(width, height) / 2}, so setting
    \l radius to \c {height / 2} (or larger) on a square item yields a perfect circle;
    on a non-square item it produces a pill/stadium. This is how Avatar draws a
    circular image without any dedicated circle primitive.

    All appearance is caller-driven; RoundedImage adds no tokens of its own. It has no
    intrinsic size and is normally \c {anchors.fill}'d to a sized parent.

    \qml
    Rectangle {
        width: 40; height: 40; radius: 20
        RoundedImage {
            anchors.fill: parent
            source: "avatar.png"
            radius: parent.radius   // == height / 2 -> circle
        }
    }
    \endqml

    \sa Avatar, AttachmentMedia, ItemMedia, MessageContent
*/
Item {
    id: root

    /*! \qmlproperty url RoundedImage::source
        \brief The image URL, forwarded to the internal \l Image. */
    property url source

    /*! \qmlproperty real RoundedImage::radius
        \brief Corner radius of the clip mask, in pixels. \c 0 (the default) leaves the
        image rectangular; \c {height / 2} on a square item yields a circle. */
    property real radius: 0

    /*! \qmlproperty int RoundedImage::fillMode
        \brief How the image fills the item; accepts \c Image.FillMode values and is
        forwarded to the internal \l Image. Defaults to \c Image.PreserveAspectCrop. */
    property int fillMode: Image.PreserveAspectCrop

    /*! \qmlproperty enumeration RoundedImage::status
        \brief Read-only load status aliased from the internal \l Image
        (\c Image.Null, \c Loading, \c Ready or \c Error). */
    readonly property alias status: img.status

    // Source image: rendered offscreen into its own layer so the fillMode crop is
    // baked into the texture, then hidden so only the masked output is composited.
    Image {
        id: img
        objectName: "image"
        anchors.fill: parent
        source: root.source
        fillMode: root.fillMode
        smooth: true
        mipmap: true
        visible: false
        layer.enabled: true
    }

    // Mask source: opaque inside the rounded rectangle, transparent outside. Only its
    // alpha channel is used by MultiEffect; it is never drawn directly.
    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false
        Rectangle {
            objectName: "maskRect"
            anchors.fill: parent
            radius: root.radius
            // Explicitly opaque white: MultiEffect masks by alpha, so the interior
            // must be fully opaque (this is Rectangle's default, made explicit).
            color: "white"
            antialiasing: true
        }
    }

    // Masked output: the rounded, cropped image. Hidden until the image is ready so
    // nothing flashes while loading.
    MultiEffect {
        objectName: "effect"
        anchors.fill: img
        source: img
        maskEnabled: true
        maskSource: mask
        visible: img.status === Image.Ready
    }
}
