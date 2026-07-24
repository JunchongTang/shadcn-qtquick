import QtQuick
import QtQuick.Layouts

/*!
    \qmltype AttachmentActions
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief The actions slot (remove / retry / copy) of an \l Attachment.

    AttachmentActions mirrors \c .cn-attachment-actions: shrink-0, items-center,
    z-20 so it always sits above the \l AttachmentTrigger overlay and stays
    independently clickable. In horizontal orientation the buttons sit adjacent
    at the right edge; in vertical orientation the parent floats it top-right with
    gap-1. Populate it with \l AttachmentAction buttons.

    \sa AttachmentAction, Attachment
*/
RowLayout {
    id: actions

    /*! \qmlproperty string AttachmentActions::attachSlot \readonly \brief Slot marker used by \l Attachment routing. */
    readonly property string attachSlot: "attachment-actions"

    /*!
        \qmlproperty enumeration AttachmentActions::hostOrientation
        Orientation injected by the parent \l Attachment; vertical adds gap-1.
        See \l {Attachment::orientation}.
    */
    property int hostOrientation: Attachment.Horizontal

    z: 20
    spacing: hostOrientation === Attachment.Vertical ? Theme.space1 : 0
}
