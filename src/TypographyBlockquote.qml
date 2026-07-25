import QtQuick

/*!
    \qmltype TypographyBlockquote
    \inqmlmodule Shadcn
    \inherits Item
    \brief A block quotation, styled after shadcn's base-mira \c blockquote.

    TypographyBlockquote renders shadcn's \c blockquote prose style:
    \c border-l-2 (a 2px left rule in the \l {Theme::border}{border} color),
    \c pl-6 (24px left padding) and \c italic body text (16px,
    \l {Theme::foreground}{foreground}). Outer spacing (\c mt-6) is left to
    the surrounding layout.

    \qmlproperty string TypographyBlockquote::text
    The quotation text.

    \qml
    TypographyBlockquote {
        width: 400
        text: "After all, everyone enjoys a good joke."
    }
    \endqml
*/
Item {
    id: root

    // Quotation text, forwarded to the inner label.
    property alias text: quote.text

    implicitWidth: quote.implicitWidth + 24   // pl-6
    implicitHeight: quote.implicitHeight

    // border-l-2: 2px left rule spanning the full height.
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 2
        color: Theme.border
    }

    Text {
        id: quote
        anchors.left: parent.left
        anchors.leftMargin: 24            // pl-6
        anchors.right: parent.right
        color: Theme.foreground
        font.family: Theme.fontSans
        font.pixelSize: Theme.textBase    // text-base (16)
        font.italic: true                 // italic
        lineHeight: 1.6
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
        textFormat: Text.PlainText
    }
}
