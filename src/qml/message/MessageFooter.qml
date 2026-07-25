import QtQuick
import QtQuick.Layouts

/*!
    \qmltype MessageFooter
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief The status / actions line shown below the bubble.

    MessageFooter is the QML port of shadcn's base-mira \c .cn-message-footer
    (\c {text-[0.625rem] font-medium text-muted-foreground px-2.5}, plus
    \c {group-data-[align=end]/message:justify-end}). It lays out an optional status
    label followed by any default children (typically a \l MessageActions group).

    The row's side is decided by its parent \l MessageContent through
    \c Layout.alignment, so it hugs the same edge as the bubble.

    \note Fidelity: the base-mira \c px-2.5 horizontal padding (which lines the
    footer text up with the bubble text) is not reproduced here, and it is not
    dropped to \c px-0 for the ghost variant.

    \sa MessageContent, MessageActions, MessageHeader
*/
RowLayout {
    id: root

    /*! Status text shown before the default children (e.g. "Delivered", "Failed to send"). */
    property string text: ""

    /*! When true the status \l text uses the destructive color instead of muted-foreground. */
    property bool destructive: false

    /*! \qmlproperty list<QtObject> MessageFooter::content
        Default children appended after the status text (e.g. a \l MessageActions group). */
    default property alias content: root.data

    spacing: Theme.space2                       // gap-2

    Text {
        visible: root.text !== ""
        text: root.text
        color: root.destructive ? Theme.destructive : Theme.mutedForeground
        font.pixelSize: 10                      // text-[0.625rem]
        font.weight: Font.Medium
    }
}
