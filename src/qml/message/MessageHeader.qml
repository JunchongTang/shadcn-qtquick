import QtQuick
import QtQuick.Layouts

/*!
    \qmltype MessageHeader
    \inqmlmodule Shadcn
    \inherits Text
    \brief The sender name / meta line shown above the bubble.

    MessageHeader is the QML port of shadcn's base-mira \c .cn-message-header
    (\c {text-[0.625rem] font-medium text-muted-foreground px-2.5}). It renders a
    small 10px medium muted-foreground label with \c px-2.5 horizontal padding so
    the text lines up with the bubble's own text inset.

    The header is hidden when \l text is empty and left-aligned within the content
    column.

    \note Fidelity: base-mira drops the padding to \c px-0 for the ghost variant
    (\c {group-has-data-[variant=ghost]/message:px-0}); this port keeps a fixed
    \c px-2.5. The header stays left-aligned rather than following the row's
    \c align (base-mira applies \c self-end to content children when
    \c {align=end}).

    \sa MessageContent, MessageFooter
*/
Text {
    id: root

    text: ""
    visible: text !== ""
    color: Theme.mutedForeground
    font.pixelSize: 10                 // text-[0.625rem]
    font.weight: Font.Medium
    leftPadding: Theme.space2_5        // px-2.5
    rightPadding: Theme.space2_5
    elide: Text.ElideRight
    Layout.alignment: Qt.AlignLeft
    Layout.maximumWidth: parent ? parent.width : implicitWidth
}
