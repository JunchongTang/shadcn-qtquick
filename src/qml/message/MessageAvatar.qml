import QtQuick
import QtQuick.Layouts

/*!
    \qmltype MessageAvatar
    \inqmlmodule Shadcn
    \inherits Item
    \brief The avatar slot of a message row.

    MessageAvatar is the QML port of shadcn's base-mira \c .cn-message-avatar
    (\c {min-w-8 shrink-0 self-end rounded-full bg-muted}). It reserves a fixed
    32px (\c min-w-8) column, bottom-aligned within the row (\c self-end), and
    fills it with an \l Avatar.

    When neither \l source nor \l fallback is set the slot renders as a 32px-wide
    transparent spacer. This mirrors the official \c {<MessageAvatar />} empty-slot
    usage that keeps a run of grouped messages left-aligned with the last message
    that does carry an avatar.

    \note The official \c -translate-y-8 (avatar lifts to the bubble bottom when a
    footer is present) is not implemented; the avatar is always bottom-aligned here.

    \sa Message, Avatar
*/
Item {
    id: root

    /*! Avatar image source. \sa Avatar::source */
    property url source

    /*! Avatar fallback text (initials) shown when no image is available. */
    property string fallback: ""

    /*! \internal True when the slot is an empty spacer (no image and no fallback). */
    readonly property bool _empty: String(source) === "" && fallback === ""

    implicitWidth: Theme.space8      // min-w-8 = 32
    implicitHeight: Theme.space8
    Layout.alignment: Qt.AlignBottom // self-end

    Avatar {
        anchors.fill: parent
        visible: !root._empty
        source: root.source
        fallback: root.fallback
    }
}
