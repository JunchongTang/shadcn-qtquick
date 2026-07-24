import QtQuick

/*!
    \qmltype AttachmentTrigger
    \inqmlmodule Shadcn
    \inherits Item
    \brief Makes the whole \l Attachment card activatable.

    AttachmentTrigger mirrors \c .cn-attachment-trigger (absolute inset-0 z-10):
    it covers the whole card but sits below the actions, so action buttons stay
    independently clickable.

    It is a non-rendering marker child. When the parent \l Attachment detects it,
    it lays a focusable button overlay below the card content; a click or Enter
    calls this component's \l clicked signal and emits \l {Attachment::triggered}.
    \l label carries the accessibility name (mirrors aria-label). Connect
    \l clicked to run the real open/select logic.

    \sa Attachment
*/
Item {
    id: trigger

    /*! \qmlproperty string AttachmentTrigger::attachSlot \readonly \brief Slot marker used by \l Attachment routing. */
    readonly property string attachSlot: "attachment-trigger"
    /*! \qmlproperty string AttachmentTrigger::label \brief Accessibility label (mirrors aria-label). */
    property string label: ""

    /*! \qmlsignal AttachmentTrigger::clicked() \brief Emitted when the card's trigger overlay is activated. */
    signal clicked()

    visible: false
    width: 0
    height: 0
}
