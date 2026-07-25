import QtQuick

/*!
    \qmltype TypographyH3
    \inqmlmodule Shadcn
    \inherits Text
    \brief A subsection heading, styled after shadcn's base-mira \c h3.

    TypographyH3 renders shadcn's \c h3 prose style: \c text-2xl (24px),
    \c font-semibold and \c tracking-tight (-0.025em) in the
    \l {Theme::foreground}{foreground} color. The line height matches
    Tailwind's \c text-2xl default (32px / 24px = 1.333).

    Being a plain \l Text, it exposes the full \c text and \c font API of
    its base type.

    \qml
    TypographyH3 { text: "The Joke Tax" }
    \endqml
*/
Text {
    color: Theme.foreground
    font.family: Theme.fontHeading
    font.pixelSize: 24                   // text-2xl
    font.weight: Font.DemiBold           // font-semibold (600)
    font.letterSpacing: -0.6             // tracking-tight: -0.025em * 24
    lineHeight: 1.333                    // text-2xl line-height: 32 / 24
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
