import QtQuick

/*!
    \qmltype TypographyLead
    \inqmlmodule Shadcn
    \inherits Text
    \brief A lead paragraph, styled after shadcn's base-mira \c Lead.

    TypographyLead renders shadcn's \c Lead prose style: \c text-xl (20px)
    regular text in the \l {Theme::mutedForeground}{muted-foreground} color,
    used to introduce a section. The line height matches Tailwind's
    \c text-xl default (28px / 20px = 1.4).

    Being a plain \l Text, it exposes the full \c text and \c font API of
    its base type.

    \qml
    TypographyLead { text: "A modal dialog that interrupts the user." }
    \endqml
*/
Text {
    color: Theme.mutedForeground         // text-muted-foreground
    font.family: Theme.fontSans
    font.pixelSize: 20                   // text-xl
    font.weight: Font.Normal
    lineHeight: 1.4                      // text-xl line-height: 28 / 20
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
