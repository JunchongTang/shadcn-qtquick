import QtQuick

/*!
    \qmltype Avatar
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief A rounded-full avatar that shows an image and falls back to initials.

    Avatar renders a circular image (\l source). While the image is loading or
    if it fails to load (or when no source is set), it shows the \l fallback
    text centred on a muted circle. Circular cropping is handled by RoundedImage
    (a MultiEffect mask): a plain Rectangle \c clip only cuts to the rectangular
    bounds, never to the radius. A subtle 1px border ring is drawn on top to
    match the reference's \c after:border outline.

    Ported from shadcn/ui (base-mira).
*/
Rectangle {
    id: control

    /*!
        \qmlproperty enumeration Avatar::size

        The avatar diameter preset.

        \value Avatar.Default 32px (\c size-8), the default.
        \value Avatar.Sm 24px (\c size-6).
        \value Avatar.Lg 40px (\c size-10).
    */
    enum Size { Default, Sm, Lg }
    property int size: Avatar.Default

    /*! \qmlproperty url Avatar::source
        The image URL. Cropped to a circle; hidden until \c Image.Ready. */
    property url source

    /*! \qmlproperty string Avatar::fallback
        Text (typically initials) shown while the image is not ready. */
    property string fallback: ""

    // Diameter for the active size preset (sm 24 / default 32 / lg 40).
    readonly property real _d: size === Avatar.Sm ? 24 : size === Avatar.Lg ? 40 : 32
    implicitWidth: _d
    implicitHeight: _d
    radius: _d / 2
    color: Theme.muted

    // Fallback initials (shown before the image is ready / on failure), on the
    // muted circle. Reference: text-sm (14), text-xs (12) for the sm size;
    // no font-weight override, so normal weight.
    Text {
        anchors.centerIn: parent
        visible: img.status !== Image.Ready
        text: control.fallback
        color: Theme.mutedForeground
        font.pixelSize: control.size === Avatar.Sm ? Theme.textXs : Theme.textSm
        font.weight: Font.Normal
    }

    // Circular image (radius == diameter/2 -> perfect circle).
    RoundedImage {
        id: img
        anchors.fill: parent
        source: control.source
        radius: control.radius
    }

    // Border ring (reference: after:border after:border-border), drawn above
    // the image so it outlines the avatar edge. The reference's
    // mix-blend-darken / mix-blend-lighten is not replicated.
    Rectangle {
        anchors.fill: parent
        radius: control.radius
        color: "transparent"
        antialiasing: true
        border.width: 1
        border.color: Theme.border
    }
}
