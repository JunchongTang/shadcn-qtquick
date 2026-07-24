import QtQuick
import QtQuick.Layouts

/*!
    \qmltype EmptyDescription
    \inqmlmodule Shadcn
    \inherits Text
    \brief Muted description text for an Empty, matching base-mira EmptyDescription.

    Mirrors \c .cn-empty-description (text-xs/relaxed text-muted-foreground;
    centered, wrapping). Font is text-xs (12px) with relaxed line height (1.625).

    \note The web variant styles nested links (\c{[&>a]:underline},
    \c{[&>a:hover]:text-primary}); rich-text link styling is not modelled here.
*/
Text {
    Layout.fillWidth: true
    color: Theme.mutedForeground
    font.pixelSize: Theme.textXs         // text-xs = 12
    lineHeight: Theme.lineRelaxed        // /relaxed = 1.625
    lineHeightMode: Text.ProportionalHeight
    horizontalAlignment: Text.AlignHCenter
    wrapMode: Text.Wrap
}
