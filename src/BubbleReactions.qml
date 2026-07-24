import QtQuick
import QtQuick.Layouts

/*!
    \qmltype BubbleReactions
    \inqmlmodule Shadcn
    \inherits Item
    \brief An emoji/action pill pinned to a \l Bubble edge.

    BubbleReactions is the QML port of shadcn's \c .cn-bubble-reactions:
    \c {absolute z-10 rounded-full bg-muted ring-2 ring-card gap-1 px-1.5 py-0.5
    text-xs}, with \c has-[button]:p-0 (drop padding when it hosts a button). The
    card-colored ring separates the pill from the bubble behind it.

    Positioned relative to the parent \l Bubble (its content box):
    \list
        \li \l side \c Above pins to the top edge, shifted up by 75% of its own
            height (\c {top-0 -translate-y-3/4}).
        \li \l side \c Below pins to the bottom edge, shifted down by 75%
            (\c {bottom-0 translate-y-3/4}).
        \li \l align \c Start sits 12px from the left (\c left-3); \c End sits 12px
            from the right (\c right-3).
    \endlist

    \note The \l Side members are \c Above/\c Below rather than \c Top/\c Bottom
    because this type derives from \c Item, whose flattened \c TransformOrigin enum
    already defines \c Top (1) and \c Bottom (7); reusing those names would collide
    (see issue #029).

    Place emoji \c Text or Button/Tooltip/Popover triggers as default children.
    Set \l padded to false when hosting an interactive control (\c has-[button]:p-0).

    \qml
    Bubble {
        BubbleContent { text: "Nice!" }
        BubbleReactions { align: Bubble.Start; Text { text: "👍" } }
    }
    \endqml

    \sa Bubble
*/
Item {
    id: reactions

    /*!
        \qmlproperty enumeration BubbleReactions::side
        Which bubble edge to pin to:
        \value BubbleReactions.Above Top edge (shifted up 75%).
        \value BubbleReactions.Below Bottom edge (shifted down 75%).
    */
    enum Side { Above, Below }

    /*! The pinned edge. \sa BubbleReactions::side */
    property int side: BubbleReactions.Below
    /*! Horizontal placement; reuses \l Bubble.Align (default trailing edge). */
    property int align: Bubble.End
    /*! When false, drops pill padding (mirrors \c has-[button]:p-0). */
    property bool padded: true

    /*! Default slot for emoji/controls. */
    default property alias items: row.data

    readonly property real _padX: padded ? Theme.space1_5 : 0   // px-1.5
    readonly property real _padY: padded ? Theme.space0_5 : 0   // py-0.5
    readonly property real _ring: 2                             // ring-2

    z: 10
    implicitWidth: pill.width
    implicitHeight: pill.height

    // Positioned relative to the parent Bubble.
    x: align === Bubble.End ? (parent ? parent.width - width - Theme.space3 : 0) : Theme.space3
    y: side === BubbleReactions.Above ? -0.75 * height
                                      : (parent ? parent.height - 0.25 * height : 0)

    // Card-colored ring (ring-2 ring-card): 2px larger on each side for separation.
    Rectangle {
        anchors.centerIn: pill
        width: pill.width + reactions._ring * 2
        height: pill.height + reactions._ring * 2
        radius: Theme.radiusFull
        color: Theme.card
    }

    Rectangle {
        id: pill
        width: row.implicitWidth + reactions._padX * 2
        height: row.implicitHeight + reactions._padY * 2
        radius: Theme.radiusFull
        color: Theme.muted

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: Theme.space1   // gap-1
        }
    }
}
