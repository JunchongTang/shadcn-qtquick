import QtQuick
import QtQuick.Layouts

/*!
    \qmltype AttachmentContent
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief The metadata column of an \l Attachment (flex-1).

    AttachmentContent mirrors \c .cn-attachment-content: a tight-leading column
    holding an \l AttachmentName and an \l AttachmentSize. It forwards the host
    upload state to its children so the name can shimmer and the size can turn
    destructive on error.

    \sa AttachmentName, AttachmentSize, Attachment
*/
ColumnLayout {
    id: content

    /*! \qmlproperty string AttachmentContent::attachSlot \readonly \brief Slot marker used by \l Attachment routing. */
    readonly property string attachSlot: "attachment-content"

    /*! \qmlproperty enumeration AttachmentContent::hostSize \brief Size injected by the parent \l Attachment. See \l {Attachment::size}. */
    property int hostSize: Attachment.Default
    /*! \qmlproperty enumeration AttachmentContent::hostState \brief Upload state injected by the parent, forwarded to children. See \l {Attachment::uploadState}. */
    property int hostState: Attachment.Done
    /*! \qmlproperty bool AttachmentContent::contentFill \brief Whether this column stretches to fill the row; cleared for secondary columns. */
    property bool contentFill: true

    Layout.alignment: Qt.AlignVCenter
    spacing: 0

    onHostStateChanged: _forward()
    Component.onCompleted: _forward()

    function _forward() {
        for (var i = 0; i < children.length; i++) {
            var c = children[i]
            if (c && c.hostState !== undefined)
                c.hostState = content.hostState
        }
    }
}
