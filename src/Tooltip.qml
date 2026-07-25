import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

/*!
    \qmltype Tooltip
    \inqmlmodule Shadcn
    \inherits ToolTip
    \brief A small inverted-color label revealed on hover, anchored to a trigger.

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
    \l sideOffset gap. It fades and zooms in / out on open / close
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

    delay: 300
    font.pixelSize: Theme.textXs
    leftPadding: Theme.space3
    // has-data-[slot=kbd]:pr-1.5 -- tighten the right padding when a Kbd is shown.
    rightPadding: kbd !== "" ? Theme.space1_5 : Theme.space3
    topPadding: Theme.space1_5
    bottomPadding: Theme.space1_5

    // Position relative to the trigger (parent) per side. For a Popup, parent is
    // the item the tooltip is declared within, i.e. the trigger element.
    x: {
        switch (side) {
        case Tooltip.Side.LeftEdge: return -width - sideOffset
        case Tooltip.Side.RightEdge: return parent ? parent.width + sideOffset : 0
        default: return parent ? (parent.width - width) / 2 : 0   // TopEdge / BottomEdge
        }
    }
    y: {
        switch (side) {
        case Tooltip.Side.TopEdge: return -height - sideOffset
        case Tooltip.Side.BottomEdge: return parent ? parent.height + sideOffset : 0
        default: return parent ? (parent.height - height) / 2 : 0  // LeftEdge / RightEdge
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
            objectName: "tooltipArrow"
            width: Theme.space2_5               // size-2.5 = 10px
            height: Theme.space2_5
            radius: 2                           // rounded-[2px]
            rotation: 45
            color: surface.color
            x: {
                switch (control.side) {
                case Tooltip.Side.LeftEdge: return surface.width - width / 2
                case Tooltip.Side.RightEdge: return -width / 2
                default: return (surface.width - width) / 2   // TopEdge / BottomEdge
                }
            }
            y: {
                switch (control.side) {
                case Tooltip.Side.TopEdge: return surface.height - height / 2
                case Tooltip.Side.BottomEdge: return -height / 2
                default: return (surface.height - height) / 2 // LeftEdge / RightEdge
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
