import QtQuick

/*!
    \qmltype TypographySmall
    \inqmlmodule Shadcn
    \inherits Text
    \brief Small emphasized text, styled after shadcn's base-mira \c Small.

    TypographySmall renders shadcn's \c Small prose style: \c text-sm (14px)
    \c font-medium text in the \l {Theme::foreground}{foreground} color with
    \c leading-none (line height 1.0), typically used for inline labels.

    Being a plain \l Text, it exposes the full \c text and \c font API of
    its base type.

    \qml
    TypographySmall { text: "Email address" }
    \endqml
*/
Text {
    color: Theme.foreground
    font.family: Theme.fontSans
    font.pixelSize: Theme.textSm         // text-sm (14)
    font.weight: Font.Medium             // font-medium (500)
    lineHeight: 1.0                      // leading-none
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
