import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

/*!
    \qmltype Tooltip
    \inqmlmodule Shadcn
    \inherits ToolTip
    \brief A small inverted-color label revealed on hover, anchored to a trigger.
    \image tooltip.png


    Port of shadcn/ui's Tooltip (base-mira style, backed by base-ui's Tooltip).
    Built on \c {QtQuick.Controls.Basic.ToolTip} (the Popup family), so declare
    it as a child of the trigger element and drive its visibility from the
    trigger's hover state (or the inherited \l delay).

    The surface mirrors \c .cn-tooltip-content: a \c {bg-foreground}
    \c {text-background} inverted pill with \c {rounded-md} corners,
    \c {px-3 py-1.5} padding, \c {text-xs} text, a \c {gap-1.5} row and a small
    diamond \l arrow pointing at the trigger. When \l kbd is set, a \l Kbd cap is
    appended to the right and the right padding tightens
    (\c {has-data-[slot=kbd]:pr-1.5}). Long text wraps within \c {max-w-xs}.

    The bubble is placed on one of four \c Side edges of the trigger with a
    \l sideOffset gap, and aligned along that edge per \l align (\l Start /
    \l Middle / \l End), offset by \l alignOffset -- the same \c side +
    \c align axes as Radix Popper / base-ui's positioning.

    The surface and its arrow are traced as a single filled \c Canvas path
    (pill outline with a triangular notch cut into the edge facing the
    trigger) rather than two overlapping semi-transparent Items. That keeps
    the fade/zoom enter/exit transition seamless: two stacked translucent
    shapes would composite differently where the arrow overlaps the pill
    versus where it pokes out over blank space, visibly splitting the arrow
    into a darker and a lighter half mid-fade. The arrow also tracks the
    trigger's centre (clamped by \l arrowPadding so it never slides into a
    rounded corner), mirroring Radix Popper's \c {arrow()} middleware: this
    keeps it pointing at the trigger even when \l align shifts the bubble
    off-centre -- e.g. a wide tooltip on a small trigger pinned to a screen
    edge.

    It fades and zooms in / out on open / close (\c {data-open:fade-in /
    zoom-in-95}).

    \note Issue #029: although \c ToolTip derives from \l Popup (not \l Item),
    the inherited \c {Item.TransformOrigin} members (\c Top = 1, \c Right = 5,
    \c Bottom = 7, \c Left = 3) still flatten into this type's enum scope. A
    naive \c {enum Side { Top, Right, Bottom, Left }} was therefore shadowed:
    \c {Tooltip.Top} resolved to \c 1 (TransformOrigin) instead of \c 0, and a
    qualified \c {Tooltip.Side.Top} (\c 0) matched none of the positioning
    cases. The members are named \c {*Edge} (like \l Sheet and \l HoverCard) so
    \c {Tooltip.Side.TopEdge} etc. resolve to the intended \c 0..3. The same
    trap catches the obvious name for a start/centre/end alignment enum: \c
    Center is also an inherited \c TransformOrigin member (\c 4), so \l align
    uses \c Start / \c Middle / \c End instead.

    \qml
    Button {
        id: btn
        text: "Hover"
        Tooltip {
            text: "Add to library"
            side: Tooltip.Side.TopEdge
            visible: btn.hovered
        }
    }
    \endqml

    \sa Popover, HoverCard, Kbd
*/
ToolTip {
    id: control

    // Edge of the trigger the bubble is placed on (documented on the side
    // property). Members are suffixed Edge to avoid the inherited
    // Item.TransformOrigin name collision (issue #029).
    enum Side { TopEdge, RightEdge, BottomEdge, LeftEdge }

    /*!
        \qmlproperty enumeration Tooltip::side
        Edge of the trigger the bubble is placed on (base-ui \c side).
        Defaults to \c Tooltip.Side.TopEdge.

        \value Tooltip.Side.TopEdge    Above the trigger. Value 0. Default.
        \value Tooltip.Side.RightEdge  To the right of the trigger. Value 1.
        \value Tooltip.Side.BottomEdge Below the trigger. Value 2.
        \value Tooltip.Side.LeftEdge   To the left of the trigger. Value 3.
    */
    property int side: Tooltip.Side.TopEdge

    /*!
        \qmlproperty real Tooltip::sideOffset
        Gap in px between the trigger and the bubble along the side axis
        (base-ui \c sideOffset). Leaves room for the \l arrow. Defaults to \c 6.
    */
    property real sideOffset: Theme.space1_5

    // Cross-axis alignment of the bubble along the trigger's edge (documented
    // on the align property). Center is renamed Middle: it too is an inherited
    // Item.TransformOrigin member (value 4) and would be shadowed (issue #029).
    enum Align { Start, Middle, End }

    /*!
        \qmlproperty enumeration Tooltip::align
        Cross-axis alignment of the bubble along the trigger's edge (base-ui /
        Radix Popper \c align), independent of \l side. Defaults to
        \c Tooltip.Align.Middle.

        \value Tooltip.Align.Start  Bubble's leading edge flush with the trigger's leading edge.
        \value Tooltip.Align.Middle Geometrically centred on the trigger. Value 1. Default.
        \value Tooltip.Align.End    Bubble's trailing edge flush with the trigger's trailing edge.
    */
    property int align: Tooltip.Align.Middle
    /*!
        \qmlproperty real Tooltip::alignOffset
        Extra shift in px along the cross axis, applied after \l align in the
        positive x/y direction regardless of which align value is set
        (base-ui / Radix Popper \c alignOffset). Defaults to \c 0.
    */
    property real alignOffset: 0

    /*!
        \qmlproperty real Tooltip::arrowPadding
        Minimum gap in px kept between the arrow and the surface's rounded
        corners while it tracks the trigger's centre (see \l arrowCenterX);
        mirrors Radix Popper's \c arrowPadding. Defaults to \l {Theme::}{radiusMd}.
    */
    property real arrowPadding: Theme.radiusMd
    /*!
        \qmlproperty real Tooltip::arrowSize
        Side length of the arrow's underlying square (base-mira's \c size-2.5,
        10px) before it is rotated 45deg into a diamond. Read-only.
    */
    readonly property real arrowSize: Theme.space2_5
    // Centre-to-vertex distance of the arrowSize-square once rotated 45deg.
    readonly property real _arrowHalfDiagonal: arrowSize * Math.SQRT2 / 2
    /*!
        \qmlproperty real Tooltip::arrowHalfWidth
        Half-width of the visible notch where it meets the pill's edge, and
        (since a 45deg-rotated square's edges run at exactly 45deg) also how
        far its tip pokes out past that edge. base-mira's diamond does not
        straddle the edge symmetrically: \c {translate-y-[calc(-50%-2px)]}
        settles its centre 2px inside the pill, so the edge slices it 2px off
        -centre rather than through the middle -- using the full half-
        diagonal here (as if bisected through the centre) would make the
        notch noticeably longer and narrower than the reference. Read-only.
    */
    readonly property real arrowHalfWidth: _arrowHalfDiagonal - 2

    // The trigger's centre, converted into this popup's own local coordinate
    // space via its own x/y offset from the trigger (the parent): correct
    // for any align value, and for any future viewport-collision shift,
    // since it is derived from the popup's actual resolved position rather
    // than assuming it is centred on the trigger.
    readonly property real _anchorX: parent ? parent.width / 2 - x : width / 2
    readonly property real _anchorY: parent ? parent.height / 2 - y : height / 2
    /*!
        \qmlproperty real Tooltip::arrowCenterX
        \qmlproperty real Tooltip::arrowCenterY
        Resolved centre of the arrow notch along the surface's edge (in the
        axis \l side does not fix), clamped by \l arrowPadding so it never
        slides into a rounded corner. Tracks the trigger's centre the way
        Radix Popper's \c {arrow()} middleware does, so the arrow keeps
        pointing at the trigger even when \l align shifts the bubble
        off-centre. Read-only.
    */
    readonly property real arrowCenterX: Math.max(arrowPadding + arrowHalfWidth,
                                          Math.min(width - arrowPadding - arrowHalfWidth, _anchorX))
    readonly property real arrowCenterY: Math.max(arrowPadding + arrowHalfWidth,
                                          Math.min(height - arrowPadding - arrowHalfWidth, _anchorY))

    /*!
        \qmlproperty string Tooltip::kbd
        Optional keyboard-shortcut hint. When non-empty a \l Kbd cap is appended
        to the right of the text and the right padding tightens to \c {pr-1.5}
        (\c {has-data-[slot=kbd]:pr-1.5}). Defaults to an empty string.
    */
    property string kbd: ""

    delay: 300
    font.pixelSize: Theme.textXs
    leftPadding: Theme.space3
    // has-data-[slot=kbd]:pr-1.5 -- tighten the right padding when a Kbd is shown.
    rightPadding: kbd !== "" ? Theme.space1_5 : Theme.space3
    topPadding: Theme.space1_5
    bottomPadding: Theme.space1_5

    // Position relative to the trigger (parent) per side; the cross axis (the
    // branch every side falls through to) resolves via align/alignOffset
    // instead of always centering. For a Popup, parent is the item the
    // tooltip is declared within, i.e. the trigger element.
    function _crossAxis(triggerLen, ownLen) {
        switch (align) {
        case Tooltip.Align.Start: return alignOffset
        case Tooltip.Align.End:   return triggerLen - ownLen + alignOffset
        default:                  return (triggerLen - ownLen) / 2 + alignOffset  // Middle
        }
    }
    x: {
        switch (side) {
        case Tooltip.Side.LeftEdge: return -width - sideOffset
        case Tooltip.Side.RightEdge: return parent ? parent.width + sideOffset : 0
        default: return parent ? _crossAxis(parent.width, width) : 0   // TopEdge / BottomEdge
        }
    }
    y: {
        switch (side) {
        case Tooltip.Side.TopEdge: return -height - sideOffset
        case Tooltip.Side.BottomEdge: return parent ? parent.height + sideOffset : 0
        default: return parent ? _crossAxis(parent.height, height) : 0  // LeftEdge / RightEdge
        }
    }

    contentItem: RowLayout {
        spacing: Theme.space1_5                 // gap-1.5
        Text {
            Layout.maximumWidth: 320            // max-w-xs (~20rem)
            text: control.text
            font: control.font
            color: Theme.background             // inverted: light text on a dark surface
            wrapMode: Text.Wrap
            maximumLineCount: 8
        }
        Kbd {
            visible: control.kbd !== ""
            text: control.kbd
        }
    }

    // Surface + arrow (.cn-tooltip-content / .cn-tooltip-arrow) traced as one
    // filled Canvas path: the rounded pill outline with a triangular notch cut
    // into whichever edge faces the trigger, rather than two overlapping
    // semi-transparent Items. A single opaque fill in one paint means the
    // enter/exit opacity animation scales the whole shape uniformly -- no seam
    // between "arrow over the pill" and "arrow over blank space" compositing
    // differently mid-fade (see the class docs above). The arrow's centre
    // tracks control.arrowCenterX/Y (clamped to control.arrowPadding), so it
    // keeps pointing at the trigger even when align is Start/End.
    background: Canvas {
        id: surface
        // Local mirrors of everything the path depends on: Canvas does not
        // repaint on arbitrary property reads inside onPaint, only through
        // these explicit onChanged handlers (same pattern as Chart.qml).
        property real pillW: control.width
        property real pillH: control.height
        property real arrowX: control.arrowCenterX
        property real arrowY: control.arrowCenterY
        property int side: control.side
        property real cornerRadius: Theme.radiusMd
        property color fillColor: Theme.foreground
        // Half-width of the notch where it meets the pill's edge, which (for
        // a 45deg-rotated square) also equals how far its tip pokes out --
        // see control.arrowHalfWidth for why this isn't simply arrowSize/2.
        property real depth: control.arrowHalfWidth

        // A Canvas rasterises exactly its own width x height -- unlike the
        // old plain Rectangle, whose child arrow could overflow its bounds
        // unclipped, anything this path draws past the canvas edge is simply
        // not there. Pad every side by depth and inset the pill by the same
        // margin (see _trace) so the poking-out tip still gets real pixels,
        // while the pill itself keeps occupying exactly the popup's own
        // (0,0)-(pillW,pillH) box (Popup.clip is false, so this overflow
        // renders unclipped against the trigger, same as before).
        x: -depth
        y: -depth
        width: pillW + 2 * depth
        height: pillH + 2 * depth

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onArrowXChanged: requestPaint()
        onArrowYChanged: requestPaint()
        onSideChanged: requestPaint()
        onCornerRadiusChanged: requestPaint()
        onFillColorChanged: requestPaint()
        onDepthChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.fillStyle = fillColor
            ctx.beginPath()
            _trace(ctx)
            ctx.fill()
        }

        // Traces the rounded-rect pill (inset by depth into this padded
        // canvas) clockwise from the top-left corner, replacing the straight
        // run along whichever edge faces the trigger with a notch out to a
        // point. The notch's half-width at the pill edge and its poke-out
        // depth are the same value (depth) -- see control.arrowHalfWidth.
        function _trace(ctx) {
            var m = depth, w = pillW, h = pillH, r = cornerRadius
            var cx = m + arrowX, cy = m + arrowY

            ctx.moveTo(m + r, m)
            if (side === Tooltip.Side.BottomEdge) {
                ctx.lineTo(cx - depth, m); ctx.lineTo(cx, m - depth); ctx.lineTo(cx + depth, m)
            }
            ctx.lineTo(m + w - r, m)
            ctx.arcTo(m + w, m, m + w, m + r, r)
            if (side === Tooltip.Side.LeftEdge) {
                ctx.lineTo(m + w, cy - depth); ctx.lineTo(m + w + depth, cy); ctx.lineTo(m + w, cy + depth)
            }
            ctx.lineTo(m + w, m + h - r)
            ctx.arcTo(m + w, m + h, m + w - r, m + h, r)
            if (side === Tooltip.Side.TopEdge) {
                ctx.lineTo(cx + depth, m + h); ctx.lineTo(cx, m + h + depth); ctx.lineTo(cx - depth, m + h)
            }
            ctx.lineTo(m + r, m + h)
            ctx.arcTo(m, m + h, m, m + h - r, r)
            if (side === Tooltip.Side.RightEdge) {
                ctx.lineTo(m, cy + depth); ctx.lineTo(m - depth, cy); ctx.lineTo(m, cy - depth)
            }
            ctx.lineTo(m, m + r)
            ctx.arcTo(m, m, m + r, m, r)
            ctx.closePath()
        }
    }

    // Open / close animation: fade + zoom-95 (data-open:fade-in / zoom-in-95).
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durFast }
        NumberAnimation { property: "scale"; from: 0.95; to: 1; duration: Theme.durFast }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durFast }
        NumberAnimation { property: "scale"; from: 1; to: 0.95; duration: Theme.durFast }
    }
}
