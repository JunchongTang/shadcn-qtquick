import QtQuick

/*!
    \qmltype TypographyP
    \inqmlmodule Shadcn
    \inherits Text
    \brief A body paragraph, styled after shadcn's base-mira \c p.

    TypographyP renders shadcn's paragraph prose style: 16px
    (\c text-base) regular text in the \l {Theme::foreground}{foreground}
    color with \c leading-7 (28px line height, 28 / 16 = 1.75). Inter-paragraph
    spacing (\c mt-6 via \c {[&:not(:first-child)]}) is left to the surrounding
    layout, so the type itself stays reusable.

    Being a plain \l Text, it exposes the full \c text and \c font API of
    its base type.

    \qml
    TypographyP { text: "The king repealed the joke tax." }
    \endqml
*/
Text {
    color: Theme.foreground
    font.family: Theme.fontSans
    font.pixelSize: Theme.textBase       // text-base (16)
    font.weight: Font.Normal
    lineHeight: 1.75                     // leading-7: 28 / 16
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
