import QtQuick
import QtQuick.Layouts

/*!
    \qmltype AttachmentName
    \inqmlmodule Shadcn
    \inherits Text
    \brief The attachment file name (web \c AttachmentTitle).

    AttachmentName renders the file name as text-xs, font-medium, single-line
    truncated. While the host is \c Uploading or \c Processing the title shimmers;
    here that is approximated with an opacity breathing loop instead of the web
    gradient sweep.

    \sa AttachmentContent, AttachmentSize
*/
Text {
    id: name

    /*!
        \qmlproperty string AttachmentName::attachSlot
        \readonly Slot marker used by AttachmentContent forwarding.
    */
    readonly property string attachSlot: "attachment-name"
    /*!
        \qmlproperty enumeration AttachmentName::hostState
        Upload state injected by the host; drives the shimmer. See \l {Attachment::uploadState}.
    */
    property int hostState: Attachment.Done

    readonly property bool _shimmer: hostState === Attachment.Uploading
                                   || hostState === Attachment.Processing

    color: Theme.foreground
    font.pixelSize: Theme.textXs
    font.weight: Font.Medium
    elide: Text.ElideRight            // truncate (single line)
    Layout.fillWidth: true

    // Shimmer approximation: gentle opacity breathing while in progress.
    SequentialAnimation {
        id: shimmerAnim
        running: name._shimmer && name.visible
        loops: Animation.Infinite
        NumberAnimation { target: name; property: "opacity"; from: 1.0; to: 0.5; duration: 700; easing.type: Easing.InOutSine }
        NumberAnimation { target: name; property: "opacity"; from: 0.5; to: 1.0; duration: 700; easing.type: Easing.InOutSine }
    }
    onHostStateChanged: if (!_shimmer) opacity = 1.0
}
