import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Effects

/*!
    \qmltype HoverCard
    \inqmlmodule Shadcn
    \inherits Item
    \brief A rich-content overlay revealed on pointer hover.
    \image hover-card.png


    Port of shadcn/ui's HoverCard (base-mira style, backed by base-ui's
    PreviewCard). Declare it as a child of the trigger element: the card
    opens after \l delay while the pointer rests over the trigger and closes
    after \l closeDelay once the pointer leaves. Moving the pointer into the
    card keeps it open.

    The visual surface reuses the Popover styling (\c {rounded-lg} + \c {p-2.5}
    + \c {ring-1 ring-foreground/10} + \c {shadow-md} + fade/zoom transition).
    Children written inside \c {HoverCard { ... }} become the card content;
    the internal machinery (hover probes, timers, Popup) is attached
    explicitly to \c data so it never lands in the default content property.

    \note Issue #029: the root is an \l Item, whose inherited
    \c {Item.TransformOrigin} members (\c Top, \c Right, \c Bottom, \c Left,
    \c Center, ...) flatten into this type's scope. The \c Side and \c Align
    enum members are therefore named \c {*Edge} / \c Middle to avoid colliding
    with those inherited names, which would otherwise resolve to the wrong
    integer values and silently break positioning.

    \qml
    Button {
        text: "Hover me"
        HoverCard {
            side: HoverCard.Side.BottomEdge
            Text { text: "Rich content"; color: Theme.foreground }
        }
    }
    \endqml
*/
Item {
    id: control

    // Placement of the card relative to the trigger. Members are suffixed Edge to avoid
    // the inherited Item.TransformOrigin name collision (issue #029).
    enum Side { TopEdge, RightEdge, BottomEdge, LeftEdge }
    /*!
        \qmlproperty enumeration HoverCard::side
        Placement side. Defaults to \c HoverCard.Side.BottomEdge.

        \value HoverCard.Side.TopEdge Above the trigger. Value 0.
        \value HoverCard.Side.RightEdge To the right of the trigger. Value 1.
        \value HoverCard.Side.BottomEdge Below the trigger. Value 2. Default.
        \value HoverCard.Side.LeftEdge To the left of the trigger. Value 3.
    */
    property int side: HoverCard.Side.BottomEdge

    // Alignment of the card along the trigger's cross axis. Middle replaces Center to
    // avoid the inherited Item.TransformOrigin.Center collision (issue #029).
    enum Align { Start, Middle, End }
    /*!
        \qmlproperty enumeration HoverCard::align
        Cross-axis alignment. Defaults to \c HoverCard.Align.Middle.

        \value HoverCard.Align.Start Align to the leading edge. Value 0.
        \value HoverCard.Align.Middle Center on the trigger. Value 1. Default.
        \value HoverCard.Align.End Align to the trailing edge. Value 2.
    */
    property int align: HoverCard.Align.Middle

    /*!
        \qmlproperty int HoverCard::sideOffset
        Gap between card and trigger along the side axis. Defaults to \c 4.
    */
    property int sideOffset: 4

    /*!
        \qmlproperty int HoverCard::alignOffset
        Additional shift along the alignment axis for the \c Start and \c End
        alignments (base-ui \c alignOffset). Not applied to \c Middle so a
        centered card stays centered. Defaults to \c 4.
    */
    property int alignOffset: 4

    /*!
        \qmlproperty int HoverCard::delay
        Milliseconds the pointer must rest on the trigger before opening. Defaults to \c 600.
    */
    property int delay: 600
    /*!
        \qmlproperty int HoverCard::closeDelay
        Milliseconds after the pointer leaves before closing. Defaults to \c 300.
    */
    property int closeDelay: 300

    /*!
        \qmlproperty int HoverCard::cardWidth
        Card width in px (\c {w-72} = 288). Override per instance. Defaults to \c 288.
    */
    property int cardWidth: 288

    /*!
        \qmlproperty real HoverCard::availableWidth
        Content width available inside the card (width minus horizontal padding). Read-only.
    */
    readonly property alias availableWidth: popup.availableWidth
    /*!
        \qmlproperty bool HoverCard::opened
        Whether the card is currently open. Read-only.
    */
    readonly property alias opened: popup.opened
    /*!
        \qmlproperty list<QtObject> HoverCard::content
        Default property. Children written inside \c {HoverCard { ... }} are
        placed into the internal Popup with \c {p-2.5} padding.
    */
    default property alias content: popup.contentData

    // Cover the trigger element as the hover probe area. HoverHandler does not
    // consume clicks, so the underlying trigger (e.g. a Button) stays usable.
    anchors.fill: parent

    // Internal hover state; the card stays open while either is true.
    property bool _triggerHovered: false
    property bool _contentHovered: false

    // Reconcile timers whenever a hover state changes.
    function _sync() {
        if (control._triggerHovered || control._contentHovered) {
            closeTimer.stop()
            if (!popup.opened)
                openTimer.restart()
        } else {
            openTimer.stop()
            closeTimer.restart()
        }
    }

    // Machinery attached to data so it never enters the default content property.
    data: [
        // Hover over the trigger (parent = control).
        HoverHandler {
            onHoveredChanged: {
                control._triggerHovered = hovered
                control._sync()
            }
        },
        Timer {
            id: openTimer
            interval: control.delay
            onTriggered: popup.open()
        },
        Timer {
            id: closeTimer
            interval: control.closeDelay
            onTriggered: if (!control._triggerHovered && !control._contentHovered) popup.close()
        },
        C.Popup {
            id: popup

            width: control.cardWidth
            padding: Theme.space2_5            // p-2.5
            font.pixelSize: Theme.textXs       // text-xs
            modal: false
            dim: false
            closePolicy: C.Popup.NoAutoClose   // open/close driven by hover logic

            // Position by side + align relative to the trigger. control fills the
            // trigger, so control.width/height are the trigger's dimensions.
            x: {
                switch (control.side) {
                case HoverCard.Side.LeftEdge: return -width - control.sideOffset
                case HoverCard.Side.RightEdge: return control.width + control.sideOffset
                default: // TopEdge / BottomEdge -> horizontal align
                    switch (control.align) {
                    case HoverCard.Align.Start: return control.alignOffset
                    case HoverCard.Align.End: return control.width - width - control.alignOffset
                    default: return (control.width - width) / 2
                    }
                }
            }
            y: {
                switch (control.side) {
                case HoverCard.Side.TopEdge: return -height - control.sideOffset
                case HoverCard.Side.BottomEdge: return control.height + control.sideOffset
                default: // LeftEdge / RightEdge -> vertical align
                    switch (control.align) {
                    case HoverCard.Align.Start: return control.alignOffset
                    case HoverCard.Align.End: return control.height - height - control.alignOffset
                    default: return (control.height - height) / 2
                    }
                }
            }

            // Popover surface: rounded-lg + ring-1 ring-foreground/10 + shadow-md.
            background: Rectangle {
                color: Theme.popover
                radius: Theme.radiusLg
                border.width: Theme.overlayRingWidth
                border.color: Theme.overlayRing
                layer.enabled: true
                layer.effect: MultiEffect {
                    autoPaddingEnabled: true
                    shadowEnabled: true
                    shadowColor: Theme.shadowColor
                    shadowBlur: Theme.shadowBlur
                    shadowVerticalOffset: Theme.shadowOffset
                }

                // Moving the pointer into the card keeps it open.
                HoverHandler {
                    onHoveredChanged: {
                        control._contentHovered = hovered
                        control._sync()
                    }
                }
            }

            // Open/close animation: fade + zoom-95 (data-open:fade-in/zoom-in-95).
            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durFast }
                NumberAnimation { property: "scale"; from: 0.95; to: 1; duration: Theme.durFast }
            }
            exit: Transition {
                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durFast }
                NumberAnimation { property: "scale"; from: 1; to: 0.95; duration: Theme.durFast }
            }
        }
    ]
}
