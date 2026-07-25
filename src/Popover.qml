import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Effects

/*!
    \qmltype Popover
    \inqmlmodule Shadcn
    \inherits Popup
    \brief A trigger-anchored overlay that shows arbitrary rich content.

    Port of shadcn/ui's Popover (base-mira style, backed by base-ui's Popover).
    QtQuick.Controls has no dedicated Popover type, so this is built on
    \c {QtQuick.Controls.Basic.Popup} (the same family as Menu and Dialog).

    Declare it as a child of the trigger element: the popup uses that element as
    its \c parent, opening below it (\c {side="bottom"}) with a \l sideOffset gap
    and horizontally placed per \l align. Children written inside
    \c {Popover { ... }} become the popup content (default \c contentData) and
    are laid out with \c {p-2.5} padding.

    The surface mirrors \c .cn-popover-content: \c {rounded-lg} + \c {p-2.5} +
    \c {ring-1 ring-foreground/10} + \c {shadow-md} + a fade / zoom-95 transition.

    It is dismissed by pressing outside or by \c Escape (non-modal, no dim), and
    is the base building block for \l DatePicker, \l DateRangePicker and the
    surface of \l HoverCard.

    \note Unlike \l HoverCard, Popover derives from \l Popup (not \l Item), so
    the inherited \c {Item.TransformOrigin} enum does not leak into scope; the
    \l Align members \c Start / \c Center / \c End are therefore free of the
    name collision described in issue #029.

    \qml
    Button {
        text: "Open popover"
        Popover {
            id: pop
            align: Popover.Align.Start
            Text { text: "Popover content"; color: Theme.popoverForeground }
        }
        onClicked: pop.open()
    }
    \endqml

    \sa HoverCard, DatePicker
*/
C.Popup {
    id: control

    /*!
        \qmlproperty enumeration Popover::align
        Horizontal alignment of the popup relative to the trigger (base-ui
        \c align). Members map to values 0/1/2; there is no collision with any
        inherited enum since Popup is not an \l Item.
        \value Popover.Align.Start Align the popup's left edge to the trigger's left. Value 0.
        \value Popover.Align.Center Center the popup over the trigger. Value 1. Default.
        \value Popover.Align.End Align the popup's right edge to the trigger's right. Value 2.
    */
    enum Align { Start, Center, End }

    /*! \qmlproperty int Popover::align \brief Horizontal alignment; see \l Align. Defaults to \c Popover.Align.Center. */
    property int align: Popover.Align.Center

    /*!
        \qmlproperty int Popover::sideOffset
        Gap in px between the trigger and the popup along the side axis (base-ui
        \c sideOffset). The popup always opens below the trigger. Defaults to \c 4.
    */
    property int sideOffset: 4

    /*!
        \qmlproperty int Popover::width
        Popup width in px. Defaults to \c 288 (\c {w-72}); override per instance
        for the narrower variants seen in the examples (\c {w-80} / \c {w-64} /
        \c {w-40}).
    */
    width: 288
    padding: Theme.space2_5            // p-2.5
    font.pixelSize: Theme.textXs       // text-xs
    modal: false
    dim: false
    closePolicy: C.Popup.CloseOnEscape | C.Popup.CloseOnPressOutside

    // Position below the trigger (parent); horizontal offset follows align.
    // A Popup uses the item it is declared within as its parent, so
    // parent.width / parent.height are the trigger's dimensions.
    y: (parent ? parent.height : 0) + sideOffset
    x: {
        if (!parent)
            return 0
        switch (align) {
        case Popover.Align.Start: return 0
        case Popover.Align.End: return parent.width - width
        default: return (parent.width - width) / 2
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
