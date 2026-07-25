import QtQuick

/*!
    \qmltype TypographyH1
    \inqmlmodule Shadcn
    \inherits Text
    \brief A top-level heading, styled after shadcn's base-mira \c h1.

    TypographyH1 renders shadcn's \c h1 prose style: \c text-4xl (36px),
    \c font-extrabold and \c tracking-tight (-0.025em) in the
    \l {Theme::foreground}{foreground} color. The line height matches
    Tailwind's \c text-4xl default (40px / 36px = 1.111). Outer spacing
    (\c mt-*) and centering (\c text-center) are left to the surrounding
    layout, so the type itself stays reusable.

    Being a plain \l Text, it exposes the full \c text and \c font API of
    its base type.

    \qml
    TypographyH1 { text: "Taxing Laughter: The Joke Tax Chronicles" }
    \endqml
*/
Text {
    color: Theme.foreground
    font.family: Theme.fontHeading
    font.pixelSize: 36                   // text-4xl
    font.weight: Font.ExtraBold          // font-extrabold (800)
    font.letterSpacing: -0.9             // tracking-tight: -0.025em * 36
    lineHeight: 1.111                    // text-4xl line-height: 40 / 36
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
