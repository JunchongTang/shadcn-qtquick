import QtQuick
import QtQuick.Layouts

/*!
    \qmltype CardTitle
    \inqmlmodule Shadcn
    \inherits Text
    \brief Card heading (cn-card-title cn-font-heading): text-sm font-medium.
*/
Text {
    Layout.fillWidth: true
    color: Theme.cardForeground
    // cn-font-heading maps to the heading family token.
    font.family: Theme.fontHeading
    font.pixelSize: Theme.textSm
    font.weight: Font.Medium
    wrapMode: Text.Wrap
}
