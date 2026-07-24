import QtQuick

/*!
    \qmltype FormMessage
    \inqmlmodule Shadcn
    \inherits Text
    \brief Destructive validation message for a form field.

    Ports shadcn/ui \c FieldError (base-mira \c .cn-field-error:
    \c text-destructive \c text-xs/relaxed). Upstream the message text is
    produced by react-hook-form + zod; QML has no equivalent, so this element
    simply displays the caller-supplied \l text in the destructive colour and
    hides itself when the text is empty.
*/
Text {
    color: Theme.destructive
    font.pixelSize: Theme.textXs          // text-xs
    lineHeight: Theme.lineRelaxed         // leading-relaxed
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    visible: text !== ""
}
