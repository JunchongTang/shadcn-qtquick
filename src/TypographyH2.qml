import QtQuick

/*!
    \qmltype TypographyH2
    \inqmlmodule Shadcn
    \inherits Item
    \brief A section heading with a bottom rule, styled after shadcn's
    base-mira \c h2.

    TypographyH2 renders shadcn's \c h2 prose style: \c text-3xl (30px),
    \c font-semibold and \c tracking-tight (-0.025em) in the
    \l {Theme::foreground}{foreground} color, followed by \c pb-2 (8px) of
    padding and a 1px \l {Theme::border}{border} rule (\c border-b) spanning
    the full width. The line height matches Tailwind's \c text-3xl default
    (36px / 30px = 1.2).

    \qml
    TypographyH2 { width: 400; text: "The People of the Kingdom" }
    \endqml
*/
Item {
    id: root

    /*!
        \qmlproperty string TypographyH2::text
        The heading text.
    */
    // Heading text, forwarded to the inner label.
    property alias text: label.text

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight + 8 + 1   // pb-2 (8) + border-b (1)

    Text {
        id: label
        width: root.width
        color: Theme.foreground
        font.family: Theme.fontHeading
        font.pixelSize: 30                 // text-3xl
        font.weight: Font.DemiBold         // font-semibold (600)
        font.letterSpacing: -0.75          // tracking-tight: -0.025em * 30
        lineHeight: 1.2                    // text-3xl line-height: 36 / 30
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
        textFormat: Text.PlainText
    }

    // border-b: 1px rule beneath the pb-2 padding, spanning the full width.
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Theme.border
    }
}
