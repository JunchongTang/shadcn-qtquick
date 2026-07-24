import QtQuick

/*!
    \qmltype AspectRatio
    \inqmlmodule Shadcn
    \inherits Item
    \brief Constrains content to a fixed width-to-height ratio.

    AspectRatio is the base-mira port of shadcn's \c aspect-(--ratio) utility. It
    derives its \l height from its current \l width using \l ratio (\c {width / ratio}),
    so callers size the width (explicitly, or via a parent/Layout) and the height
    follows automatically. Child content is laid out through the default property
    and anchored to fill the box.

    \l ratio is width divided by height: \c {16 / 9} (default) is landscape,
    \c 1 is square, and \c {9 / 16} is portrait.

    Set \l color to paint a background (mirroring \c bg-muted) and \l radius to
    round it. A non-zero \l radius also clips the content box to a rectangle;
    because the clip is rectangular, image/color content that should follow the
    rounded corners must set the same radius itself (matching the official demo,
    where both the AspectRatio and its inner image carry \c rounded-lg).

    \qml
    AspectRatio {
        ratio: 16 / 9
        radius: 8
        color: Theme.muted
        Image { anchors.fill: parent; source: "photo.png"; fillMode: Image.PreserveAspectCrop }
    }
    \endqml
*/
Item {
    id: control

    /*! \qmlproperty real AspectRatio::ratio \brief Width divided by height. Defaults to \c {16 / 9}. */
    property real ratio: 16 / 9
    /*! \qmlproperty real AspectRatio::radius \brief Corner radius of the background; a non-zero value also clips content. Defaults to \c 0. */
    property real radius: 0
    /*! \qmlproperty color AspectRatio::color \brief Background fill color (e.g. \c bg-muted). Defaults to transparent. */
    property color color: "transparent"

    /*! \qmlproperty list<QtObject> AspectRatio::content \brief Default property: children placed in the ratio-constrained box. */
    default property alias content: holder.data

    implicitWidth: 320
    // Derive height from the current width; guard ratio <= 0 to avoid a
    // divide-by-zero (Infinity/NaN) height.
    implicitHeight: ratio > 0 ? width / ratio : 0
    height: ratio > 0 ? width / ratio : 0

    // Background (bg-muted + rounded-*).
    Rectangle {
        anchors.fill: parent
        color: control.color
        radius: control.radius
    }

    // Content box (fills the container, clipped when rounded).
    Item {
        id: holder
        anchors.fill: parent
        clip: control.radius > 0
    }
}
