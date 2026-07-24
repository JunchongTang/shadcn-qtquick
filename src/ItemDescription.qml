import QtQuick
import QtQuick.Layouts

/*!
    \qmltype ItemDescription
    \inqmlmodule Shadcn
    \inherits Text
    \brief Secondary description text of a \l ShadItem.

    Rendered as muted-foreground, text-xs with relaxed line height, clamped to
    two lines with a trailing ellipsis (line-clamp-2). Normal weight.
*/
Text {
    readonly property string itemSlot: "item-description"

    color: Theme.mutedForeground
    font.pixelSize: Theme.textXs
    lineHeight: Theme.lineRelaxed
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    maximumLineCount: 2          // line-clamp-2
    elide: Text.ElideRight
    Layout.fillWidth: true
}
