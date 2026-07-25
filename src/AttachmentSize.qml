import QtQuick
import QtQuick.Layouts

/*!
    \qmltype AttachmentSize
    \inqmlmodule Shadcn
    \inherits Text
    \brief Secondary attachment metadata (web \c AttachmentDescription).

    AttachmentSize renders file type / size / upload status as mt-0.5, text-xs,
    muted, single-line truncated (mirrors \c .cn-attachment-description). In the
    error state it turns destructive/80 so the failure reason is carried by the
    text rather than color alone.

    \sa AttachmentContent, AttachmentName
*/
Text {
    id: meta

    /*!
        \qmlproperty string AttachmentSize::attachSlot
        \readonly Slot marker used by AttachmentContent forwarding.
    */
    readonly property string attachSlot: "attachment-size"
    /*!
        \qmlproperty enumeration AttachmentSize::hostState
        Upload state injected by the host; error turns the text destructive. See \l {Attachment::uploadState}.
    */
    property int hostState: Attachment.Done

    readonly property bool _error: hostState === Attachment.Error

    color: _error ? Theme.alpha(Theme.destructive, 0.80) : Theme.mutedForeground
    font.pixelSize: Theme.textXs
    elide: Text.ElideRight
    Layout.fillWidth: true
    Layout.topMargin: 2          // mt-0.5
}
