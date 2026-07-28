import QtQuick

/*!
    \qmltype InputGroupText
    \inqmlmodule Shadcn
    \inherits Text
    \brief A text label inside an InputGroupAddon (\c .cn-input-group-text),
    styled after shadcn/ui base-mira.

    InputGroupText renders \c text-muted-foreground at \c text-xs with
    \c font-medium weight. Place it inside an \l InputGroupAddon. For an
    icon-plus-text combination, put a Icon and this component side by side
    in the same InputGroupAddon (the addon lays its children out horizontally).

    \sa InputGroupAddon, InputGroup
*/
Text {
    color: Theme.mutedForeground
    font.pixelSize: Theme.textXs
    font.weight: Font.Medium
    font.family: Theme.fontSans
    verticalAlignment: Text.AlignVCenter
    textFormat: Text.PlainText
}
