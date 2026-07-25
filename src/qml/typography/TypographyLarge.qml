import QtQuick

/*!
    \qmltype TypographyLarge
    \inqmlmodule Shadcn
    \inherits Text
    \brief Emphasized "large" text, styled after shadcn's base-mira
    \c Large.

    TypographyLarge renders shadcn's \c Large prose style: \c text-lg (18px)
    \c font-semibold in the \l {Theme::foreground}{foreground} color. The line
    height matches Tailwind's \c text-lg default (28px / 18px = 1.556).

    Being a plain \l Text, it exposes the full \c text and \c font API of
    its base type.

    \qml
    TypographyLarge { text: "Are you absolutely sure?" }
    \endqml
*/
Text {
    color: Theme.foreground
    font.family: Theme.fontSans
    font.pixelSize: Theme.textLg         // text-lg (18)
    font.weight: Font.DemiBold           // font-semibold (600)
    lineHeight: 1.556                    // text-lg line-height: 28 / 18
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
