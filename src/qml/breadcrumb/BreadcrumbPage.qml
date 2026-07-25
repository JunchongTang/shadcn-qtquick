import QtQuick

/*!
    \qmltype BreadcrumbPage
    \inqmlmodule Shadcn
    \inherits Text
    \brief The current (non-interactive) page in a breadcrumb trail.

    Maps to shadcn's \c{<span class="cn-breadcrumb-page">}. base-mira renders it
    in \c text-foreground with \c font-normal weight, at \c text-xs with
    \c relaxed line height. Set the inherited \c text property for the label.
*/
Text {
    color: Theme.foreground
    font.pixelSize: Theme.textXs        // text-xs
    font.family: Theme.fontSans
    font.weight: Font.Normal            // font-normal
    lineHeight: Theme.lineRelaxed       // /relaxed line height
    lineHeightMode: Text.ProportionalHeight
    verticalAlignment: Text.AlignVCenter
}
