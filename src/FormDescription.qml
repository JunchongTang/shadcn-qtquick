import QtQuick

/*!
    \qmltype FormDescription
    \inqmlmodule Shadcn
    \inherits Text
    \brief Muted helper text for a form field.

    Ports shadcn/ui \c FieldDescription (base-mira \c .cn-field-description:
    \c text-muted-foreground \c text-left \c text-xs/relaxed). Renders the
    supporting caption shown beneath a control. The element hides itself when
    its \l text is empty so it never contributes spacing to an enclosing layout.
*/
Text {
    color: Theme.mutedForeground
    horizontalAlignment: Text.AlignLeft   // text-left
    font.pixelSize: Theme.textXs          // text-xs
    lineHeight: Theme.lineRelaxed         // leading-relaxed
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    visible: text !== ""
}
