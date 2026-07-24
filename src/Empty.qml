import QtQuick
import QtQuick.Layouts

/*!
    \qmltype Empty
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief Centered empty-state container matching shadcn/ui base-mira Empty.

    Mirrors \c .cn-empty (flex-col items-center justify-center text-center;
    gap-4 rounded-xl border-dashed p-6). Children stack vertically in a centered
    ColumnLayout with 16px gap and 24px (p-6) padding on all sides.

    The base-mira border style is dashed but has zero width by default; \l outline
    turns on the 1px dashed frame (the examples' \c border class). \l surface adds
    a background fill (the \c bg-* utilities).

    Compose as: Empty { EmptyHeader { EmptyMedia; EmptyTitle; EmptyDescription }
    EmptyContent { ... } }.

    \note The web element is \c{w-full flex-1}; here the container is
    content-sized. Rich-text links inside EmptyDescription are not modelled.
*/
Rectangle {
    id: control

    /*! \qmlproperty bool Empty::outline
        When true, draws the 1px dashed frame (web \c{border border-dashed}). */
    property bool outline: false

    /*! \qmlproperty color Empty::surface
        Background fill (web \c bg-*); transparent by default. */
    property color surface: "transparent"

    /*! \qmlproperty list<QtObject> Empty::content
        Default property: items stacked in the centered inner column. */
    default property alias content: inner.data

    color: surface
    radius: Theme.radiusXl                                   // rounded-xl = 14
    implicitWidth: inner.implicitWidth + Theme.space6 * 2    // p-6 (left + right)
    implicitHeight: inner.implicitHeight + Theme.space6 * 2  // p-6 (top + bottom)

    // Rectangle has no dashed stroke, so paint the rounded dashed frame on a Canvas.
    Canvas {
        id: dashed
        anchors.fill: parent
        visible: control.outline
        property color strokeColor: Theme.border
        onStrokeColorChanged: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onVisibleChanged: requestPaint()
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            if (!control.outline)
                return
            ctx.strokeStyle = strokeColor
            ctx.lineWidth = 1
            ctx.setLineDash([4, 4])
            var r = control.radius
            var x = 0.5, y = 0.5
            var w = width - 1, h = height - 1
            ctx.beginPath()
            ctx.moveTo(x + r, y)
            ctx.arcTo(x + w, y, x + w, y + h, r)
            ctx.arcTo(x + w, y + h, x, y + h, r)
            ctx.arcTo(x, y + h, x, y, r)
            ctx.arcTo(x, y, x + w, y, r)
            ctx.closePath()
            ctx.stroke()
        }
    }

    ColumnLayout {
        id: inner
        anchors.centerIn: parent
        spacing: Theme.space4    // gap-4 = 16
    }
}
