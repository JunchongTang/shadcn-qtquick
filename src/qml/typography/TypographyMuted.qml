import QtQuick

/*!
    \qmltype TypographyMuted
    \inqmlmodule Shadcn
    \inherits Text
    \brief Muted helper text, styled after shadcn's base-mira \c Muted.

    TypographyMuted renders shadcn's \c Muted prose style: \c text-sm (14px)
    regular text in the \l {Theme::mutedForeground}{muted-foreground} color,
    used for secondary hints. The line height matches Tailwind's \c text-sm
    default (20px / 14px = 1.4286).

    Being a plain \l Text, it exposes the full \c text and \c font API of
    its base type.

    \qml
    TypographyMuted { text: "Enter your email address." }
    \endqml
*/
Text {
    color: Theme.mutedForeground         // text-muted-foreground
    font.family: Theme.fontSans
    font.pixelSize: Theme.textSm         // text-sm (14)
    font.weight: Font.Normal
    lineHeight: 1.4286                   // text-sm line-height: 20 / 14
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
