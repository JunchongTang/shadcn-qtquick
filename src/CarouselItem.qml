import QtQuick

/*!
    \qmltype CarouselItem
    \inqmlmodule Shadcn
    \inherits Item
    \brief A single slide within a \l Carousel.

    Port of shadcn/ui's CarouselItem (base-mira style). Holds arbitrary
    caller-supplied content (the default property), which fills the slide.

    The slide's extent along the carousel's scroll axis is derived from the
    parent \l Carousel viewport and \l basis: for a horizontal carousel
    \c {width = viewport.width * basis} (height fills the viewport); for a
    vertical carousel \c {height = viewport.height * basis} (width fills).
    Inter-slide spacing is provided symmetrically by the carousel's ListView,
    so slides are not offset to one side.
*/
Item {
    id: item

    /*!
        \qmlproperty real CarouselItem::basis
        Fraction of the carousel viewport this slide occupies along the scroll
        axis, mirroring the web \c basis-* utilities: \c 1.0 for
        \c basis-full (default), \c 0.5 for \c basis-1/2, \c 0.333 for
        \c basis-1/3.
    */
    property real basis: 1.0

    /*!
        \qmlproperty list<QtObject> CarouselItem::content
        Default property. The slide content, stretched to fill the slide.
    */
    default property alias content: holder.data

    readonly property var _view: ListView.view
    readonly property bool _horizontal: _view ? _view.horizontalFlow : true

    implicitWidth: _view ? (_horizontal ? _view.width * basis : _view.width) : 0
    implicitHeight: _view ? (_horizontal ? _view.height : _view.height * basis) : 0
    width: implicitWidth
    height: implicitHeight

    Item {
        id: holder
        anchors.fill: parent
    }
}
