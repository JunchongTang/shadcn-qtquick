import QtQuick

/*!
    \qmltype AttachmentGroup
    \inqmlmodule Shadcn
    \inherits Flickable
    \brief A horizontally scrollable row of \l Attachment cards.

    AttachmentGroup mirrors \c .cn-attachment-group: gap-3 (12) between cards,
    py-1 (4) vertical padding, and horizontal overflow scrolling. Declare the
    cards in the default slot; they are placed in an internal \c Row.

    The web version also snaps and fades the edges (\c scroll-fade-x /
    \c snap-mandatory); those are purely visual and omitted here.

    \sa Attachment
*/
Flickable {
    id: group

    /*!
        \qmlproperty list<QtObject> AttachmentGroup::content
        Default slot; the \l Attachment cards laid out in a row.
    */
    default property alias content: row.data

    /*!
        \qmlproperty string AttachmentGroup::attachSlot
        \readonly Slot marker (self-identification).
    */
    readonly property string attachSlot: "attachment-group"

    contentWidth: row.width
    contentHeight: row.height
    flickableDirection: Flickable.HorizontalFlick
    boundsBehavior: Flickable.StopAtBounds
    clip: true

    implicitWidth: row.implicitWidth + 8
    implicitHeight: row.implicitHeight + 8    // py-1 (4 top + 4 bottom)

    Row {
        id: row
        x: 4                                  // approximates scroll-px-1
        y: 4                                  // py-1
        spacing: 12                           // gap-3
    }
}
