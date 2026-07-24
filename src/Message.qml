import QtQuick
import QtQuick.Layouts

/*!
    \qmltype Message
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief A single row in a conversation: avatar + content bubble + header/footer + hover actions.

    Message is the QML port of shadcn's base-mira \c .cn-message. It corresponds to
    \c {flex w-full min-w-0 data-[align=end]:flex-row-reverse} with \c gap-1.5. One
    row is laid out horizontally; when \l align is \c End the whole row is mirrored
    (\c flex-row-reverse) so the avatar sits on the right and the content hugs the
    trailing edge.

    The family is self-contained: the content bubble is drawn by \l MessageContent
    directly (it does not depend on \l Bubble).

    Composition (mirrors the registry parts):
    \qml
    Message {
        align: Message.End
        MessageAvatar { source: "qrc:/me.png"; fallback: "ME" }   // optional; empty slot acts as a spacer
        MessageContent {
            header: "Olivia"
            text: "Deploying to prod real quick."
            variant: MessageContent.Default
            footer: "Delivered"
            // default children become hover action buttons (IconButton size=Small variant=Ghost)
        }
    }
    \endqml

    Children read this row's \l align through the parent chain (via \c isMessageRow),
    so the user only sets it once on the Message.

    Honest omissions (base tier): \l MessageGroup fine-grained stacking (approximate
    with a tight-spacing ColumnLayout), the base-mira \c -translate-y-8 that lifts the
    avatar to the bubble bottom when a footer exists, rich text / markdown, and real
    streaming (only a \c typing dot animation is offered).

    \sa MessageAvatar, MessageContent, MessageHeader, MessageFooter, MessageActions
*/
RowLayout {
    id: root

    /*!
        \qmlproperty enumeration Message::align
        Which side the row is anchored to.
        \value Message.Start Incoming message: avatar left, content hugs the leading edge.
        \value Message.End Outgoing message: row mirrored, avatar right, content hugs the trailing edge.
    */
    enum Align { Start, End }

    /*! The row alignment. \sa Message::align */
    property int align: Message.Start

    /*! \internal Lets descendant content parts find this row and read \l align. */
    readonly property bool isMessageRow: true

    Layout.fillWidth: true
    spacing: Theme.space1_5             // gap-1.5
    layoutDirection: align === Message.End ? Qt.RightToLeft : Qt.LeftToRight
}
