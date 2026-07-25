import QtQuick
import QtQuick.Layouts

/*!
    \qmltype CardDescription
    \inqmlmodule Shadcn
    \inherits Text
    \brief Secondary card text (cn-card-description): text-muted-foreground text-xs/relaxed.
*/
Text {
    Layout.fillWidth: true
    color: Theme.mutedForeground
    font.pixelSize: Theme.textXs
    lineHeight: Theme.lineRelaxed
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
}
