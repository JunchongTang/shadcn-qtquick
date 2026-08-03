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
    \l sideOffset gap. It flips to the opposite edge when the window leaves no
    room on the requested one (\l effectiveSide) and slides along that edge to
    stay inside it (\l shift); the arrow keeps pointing at the trigger through
    both. It fades and zooms in / out on open / close
    (\c {data-open:fade-in / zoom-in-95}).

    \note Issue #029: although \c ToolTip derives from \l Popup (not \l Item),
    the inherited \c {Item.TransformOrigin} members (\c Top = 1, \c Right = 5,
    \c Bottom = 7, \c Left = 3) still flatten into this type's enum scope. A
    naive \c {enum Side { Top, Right, Bottom, Left }} was therefore shadowed:
    \c {Tooltip.Top} resolved to \c 1 (TransformOrigin) instead of \c 0, and a
    qualified \c {Tooltip.Side.Top} (\c 0) matched none of the positioning
    cases. The members are named \c {*Edge} (like \l Sheet and \l HoverCard) so
    \c {Tooltip.Side.TopEdge} etc. resolve to the intended \c 0..3.

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

    /*!
        \qmlproperty string Tooltip::kbd
        Optional keyboard-shortcut hint. When non-empty a \l Kbd cap is appended
        to the right of the text and the right padding tightens to \c {pr-1.5}
        (\c {has-data-[slot=kbd]:pr-1.5}). Defaults to an empty string.
    */
    property string kbd: ""

    /*!
        \qmlproperty enumeration Tooltip::effectiveSide
        The edge the bubble is actually on: \l side, or the opposite one when the
        window leaves no room there (base-ui's flip middleware). Derived state --
        read it, do not set it; assign \l side instead.

        The flip has to be decided here rather than left to Qt. \c ToolTip enables
        the positioner's vertical and horizontal flipping, so a bubble that does
        not fit is already mirrored to the other edge -- but the positioner moves
        the bubble alone, and the \l arrow is drawn by this component from \l side.
        A tooltip on a trigger at the top of a window therefore ended up below it
        with the arrow still on the bottom, pointing away at nothing. Deciding
        first, and placing both parts from the answer, keeps them together; it also
        leaves the bubble inside the window, so the positioner finds nothing to
        correct.

        \sa shift
    */
    property int effectiveSide: side

    /*!
        \qmlproperty real Tooltip::shift
        How far the bubble had to be nudged along its edge to stay inside the
        window, within \c margins (base-ui's shift middleware): negative toward the
        leading edge. Derived state, like \l effectiveSide.

        The same division of labour, and the same defect, one axis over. A bubble is
        centred on its trigger, so a control against the right edge of a window --
        the last button in a title bar, say -- carries one that overruns it, and
        Qt's positioner pushes it back inside. Once again it moves the bubble and
        not the \l arrow, which stays in the middle of a bubble that is no longer in
        the middle of anything, pointing at whatever happens to be beside the
        button. Owning the nudge here is what lets the arrow slide back the other
        way and keep pointing at its trigger.

        This is why an \c align property is not the answer to a control in a corner:
        alignment is a design decision, and having each caller declare which corner
        of the window it happens to sit in is the arrangement that produced the bug
        in the first place.
    */
    property real shift: 0

    onSideChanged: control.updatePlacement()
    onVisibleChanged: if (control.visible) control.updatePlacement()
    // The first real size arrives after the bubble is shown, so the decision made on open is
    // taken again once there is something to measure against.
    onWidthChanged: if (control.visible) control.updatePlacement()
    onHeightChanged: if (control.visible) control.updatePlacement()

    /*!
        \qmlmethod void Tooltip::updatePlacement()
        Works out \l effectiveSide and \l shift for where the trigger sits in the
        window right now.

        Called when the bubble opens or changes size, which is when the answer can
        change, rather than bound: the room available depends on the trigger's
        position in the window, and \c mapToItem() is not something a binding is
        notified about. base-ui computes placement on open for the same reason. Call
        it directly after moving a trigger under a bubble that is already showing.
    */
    function updatePlacement() {
        control.effectiveSide = control.placementFor();
        // After the edge, which decides which axis the nudge is along.
        control.shift = control.shiftFor(control.effectiveSide);
    }

    /*
        How close to the window's edge the bubble may come -- base-ui's collisionPadding,
        which Qt Quick Controls already has as Popup.margins and the Basic style's ToolTip
        already sets to 6.

        Read from there rather than added as a property of our own, because the positioner
        clamps to it whatever we think: with a padding of our own at 4 it corrected our
        placement by the remaining 2px and the arrow was 2px off its trigger, which is this
        whole class of bug in miniature. One number, on the property Qt documents for it.
        A negative margins means "no clamping" to a Popup, and no padding to us.
    */
    function edgePadding(): real {
        return Math.max(0, control.margins)
    }

    // The trigger's rectangle in window coordinates, or null with nothing to measure
    // against. Both decisions below start from it. Untyped on purpose: a declared rect
    // return cannot be null, and "no window yet" is a case both callers have to handle.
    function triggerBounds() {
        const trigger = control.parent
        if (!trigger || !trigger.Window.window || control.width <= 0 || control.height <= 0)
            return null
        const at = trigger.mapToItem(null, 0, 0)
        return Qt.rect(at.x, at.y, trigger.width, trigger.height)
    }

    // The Side value effectiveSide should take.
    function placementFor(): int {
        const bounds = control.triggerBounds()
        if (!bounds)
            return control.side

        // Free space beyond each edge of the trigger, with the gap and the window's own
        // padding already deducted: what is left for a bubble to occupy.
        const trigger = control.parent
        const spare = control.sideOffset + control.edgePadding()
        const above = bounds.y - spare
        const below = trigger.Window.height - (bounds.y + bounds.height) - spare
        const before = bounds.x - spare
        const after = trigger.Window.width - (bounds.x + bounds.width) - spare

        // Keep the requested edge when the bubble fits on it, or when the opposite edge is no
        // roomier -- moving to a side that is just as cramped only relocates the problem, and
        // the requested side is what the caller meant.
        const keeps = (mine, other, needed) => mine >= needed || mine >= other

        switch (control.side) {
        case Tooltip.Side.LeftEdge:
            return keeps(before, after, control.width) ? Tooltip.Side.LeftEdge
                                                       : Tooltip.Side.RightEdge
        case Tooltip.Side.RightEdge:
            return keeps(after, before, control.width) ? Tooltip.Side.RightEdge
                                                       : Tooltip.Side.LeftEdge
        case Tooltip.Side.BottomEdge:
            return keeps(below, above, control.height) ? Tooltip.Side.BottomEdge
                                                       : Tooltip.Side.TopEdge
        default:
            return keeps(above, below, control.height) ? Tooltip.Side.TopEdge
                                                       : Tooltip.Side.BottomEdge
        }
    }

    // How far along \a edge the bubble has to move to stay inside the window.
    function shiftFor(edge: int): real {
        const bounds = control.triggerBounds()
        if (!bounds)
            return 0

        // The cross axis: for a bubble above or below its trigger it is the horizontal one.
        const trigger = control.parent
        const sideways = edge === Tooltip.Side.TopEdge || edge === Tooltip.Side.BottomEdge
        const centred = sideways ? bounds.x + (bounds.width - control.width) / 2
                                 : bounds.y + (bounds.height - control.height) / 2
        const extent = sideways ? control.width : control.height
        const room = sideways ? trigger.Window.width : trigger.Window.height

        // Clamped between both edges, with the leading one applied last so that a bubble too
        // large for the window altogether ends up flush with the edge a reader starts from
        // rather than the one they finish at.
        const pad = control.edgePadding()
        return Math.max(pad, Math.min(room - extent - pad, centred)) - centred
    }

    delay: 300
    font.pixelSize: Theme.textXs
    leftPadding: Theme.space3
    // has-data-[slot=kbd]:pr-1.5 -- tighten the right padding when a Kbd is shown.
    rightPadding: kbd !== "" ? Theme.space1_5 : Theme.space3
    topPadding: Theme.space1_5
    bottomPadding: Theme.space1_5

    // Position relative to the trigger (parent) per side. For a Popup, parent is
    // the item the tooltip is declared within, i.e. the trigger element.
    // Position relative to the trigger, centred on the cross axis and nudged along it by
    // however much staying inside the window costs (\l shift).
    x: {
        switch (effectiveSide) {
        case Tooltip.Side.LeftEdge: return -width - sideOffset
        case Tooltip.Side.RightEdge: return parent ? parent.width + sideOffset : 0
        default: return parent ? (parent.width - width) / 2 + shift : 0   // TopEdge / BottomEdge
        }
    }
    y: {
        switch (effectiveSide) {
        case Tooltip.Side.TopEdge: return -height - sideOffset
        case Tooltip.Side.BottomEdge: return parent ? parent.height + sideOffset : 0
        default: return parent ? (parent.height - height) / 2 + shift : 0  // LeftEdge / RightEdge
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

    background: Rectangle {
        id: surface
        color: Theme.foreground
        radius: Theme.radiusMd

        // Arrow (.cn-tooltip-arrow): a 10px square (size-2.5) with 2px corners
        // (rounded-[2px]) rotated 45deg into a diamond, centered on the edge
        // that faces the trigger. Half sits inside the surface, half points out;
        // matching the surface colour keeps the join seamless.
        Rectangle {
            id: arrow

            objectName: "tooltipArrow"
            width: Theme.space2_5               // size-2.5 = 10px
            height: Theme.space2_5
            radius: 2                           // rounded-[2px]
            rotation: 45
            color: surface.color

            /*!
                \internal
                Slides back along the edge by as much as the bubble was nudged away, so that
                it goes on pointing at the trigger rather than at the middle of a bubble that
                is no longer over it. This is floating-ui's arrow middleware, and the reason
                base-ui has an arrowPadding at all.

                Stopped short of the corners, which is what that padding is for: a diamond
                over a rounded corner has nothing flat to sit against and reads as a
                rendering fault rather than as a pointer. Where the nudge is larger than the
                room to slide -- a trigger narrower than the bubble's own corner, right up
                against the window -- the arrow ends at the corner and points as close to the
                trigger as it can get.
            */
            readonly property real slide: {
                const along = control.effectiveSide === Tooltip.Side.TopEdge
                              || control.effectiveSide === Tooltip.Side.BottomEdge
                            ? surface.width : surface.height
                // A square turned 45 degrees takes up its diagonal, not its side.
                const limit = Math.max(0, (along - width * Math.SQRT2) / 2 - surface.radius)
                return Math.max(-limit, Math.min(limit, -control.shift))
            }

            x: {
                switch (control.effectiveSide) {
                case Tooltip.Side.LeftEdge: return surface.width - width / 2
                case Tooltip.Side.RightEdge: return -width / 2
                default: return (surface.width - width) / 2 + slide  // TopEdge / BottomEdge
                }
            }
            y: {
                switch (control.effectiveSide) {
                case Tooltip.Side.TopEdge: return surface.height - height / 2
                case Tooltip.Side.BottomEdge: return -height / 2
                default: return (surface.height - height) / 2 + slide // LeftEdge / RightEdge
                }
            }
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
