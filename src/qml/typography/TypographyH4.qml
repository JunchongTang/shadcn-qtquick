import QtQuick

/*!
    \qmltype TypographyH4
    \inqmlmodule Shadcn
    \inherits Text
    \brief A minor heading, styled after shadcn's base-mira \c h4.

    TypographyH4 renders shadcn's \c h4 prose style: \c text-xl (20px),
    \c font-semibold and \c tracking-tight (-0.025em) in the
    \l {Theme::foreground}{foreground} color. The line height matches
    Tailwind's \c text-xl default (28px / 20px = 1.4).

    Being a plain \l Text, it exposes the full \c text and \c font API of
    its base type.

    \qml
    TypographyH4 { text: "People stopped telling jokes" }
    \endqml
*/
Text {
    color: Theme.foreground
    font.family: Theme.fontHeading
    font.pixelSize: 20                   // text-xl
    font.weight: Font.DemiBold           // font-semibold (600)
    font.letterSpacing: -0.5             // tracking-tight: -0.025em * 20
    lineHeight: 1.4                      // text-xl line-height: 28 / 20
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
