import QtQuick
import QtQuick.Layouts

/*!
    \qmltype Bubble
    \inqmlmodule Shadcn
    \inherits Item
    \brief A chat-message bubble container.

    Bubble is the QML port of shadcn's base-mira \c .cn-bubble. It corresponds to
    \c {flex flex-col gap-1 w-fit max-w-[80%]} (the ghost variant lifts the cap to
    \c max-w-full) and \c {data-[align=end]:self-end}.

    The family mirrors the registry parts:
    \list
        \li \l Bubble — the container that carries \l variant and \l align.
        \li \l BubbleContent — the visual body (background, radius, padding, text).
        \li \l BubbleReactions — an optional pill of emoji/actions pinned to the
            bubble edge (absolutely positioned, does not affect the bubble size).
        \li \l BubbleGroup — tightens spacing for a run of same-author bubbles.
    \endlist

    The bubble's own size is bound to its \l BubbleContent (registered on
    completion); reactions overflow the bubble edge without contributing to size,
    so a conversation column should reserve extra vertical spacing.

    \qml
    ColumnLayout {                 // conversation column with a definite width
        width: 360
        Bubble {
            variant: Bubble.Muted
            align: Bubble.Start
            BubbleContent { text: "Hey!" }
            BubbleReactions { Text { text: "👍" } }
        }
    }
    \endqml

    \sa BubbleContent, BubbleReactions, BubbleGroup
*/
Item {
    id: root

    /*!
        \qmlproperty enumeration Bubble::variant
        Visual style, read by \l BubbleContent to pick background/foreground:
        \value Bubble.Default Primary background, primary-foreground text.
        \value Bubble.Secondary Secondary background/foreground.
        \value Bubble.Muted Muted background, default foreground.
        \value Bubble.Tinted Tinted (primary-hued) background, default foreground.
        \value Bubble.Outline Background fill with a visible border.
        \value Bubble.Ghost No background/border/padding; max-width lifted to 100%.
        \value Bubble.Destructive Translucent destructive background/foreground.
    */
    enum Variant { Default, Secondary, Muted, Tinted, Outline, Ghost, Destructive }

    /*!
        \qmlproperty enumeration Bubble::align
        In-column self-alignment:
        \value Bubble.Start Align to the leading edge (self-start).
        \value Bubble.End Align to the trailing edge (self-end).
    */
    enum Align { Start, End }

    /*! The visual variant. \sa Bubble::variant */
    property int variant: Bubble.Default
    /*! The in-column alignment. \sa Bubble::align */
    property int align: Bubble.Start
    /*!
        Content max-width as a fraction of the conversation column width
        (mirrors \c max-w-[80%]). \l BubbleContent lifts this to 1.0 for the ghost
        variant internally.
    */
    property real maxWidthRatio: 0.8

    /*! \internal Registered by BubbleContent on completion; drives the size. */
    property Item _contentRef: null

    implicitWidth: _contentRef ? _contentRef.implicitWidth : 0
    implicitHeight: _contentRef ? _contentRef.implicitHeight : 0

    // In-column alignment (self-start / self-end); ignored outside a Layout.
    Layout.alignment: (align === Bubble.End ? Qt.AlignRight : Qt.AlignLeft) | Qt.AlignVCenter
}
