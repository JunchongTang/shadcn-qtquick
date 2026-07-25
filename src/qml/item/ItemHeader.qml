import QtQuick.Layouts

/*!
    \qmltype ItemHeader
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief Full-width header row of a \l ShadItem, placed above the content.

    Spans the whole item (basis-full), justified with gap-2. Commonly holds a
    full-width image or a "title + action" pair. The parent \l ShadItem
    migrates it into the header zone, pinned to the top.
*/
RowLayout {
    readonly property string itemSlot: "item-header"

    Layout.fillWidth: true
    spacing: Theme.space2   // gap-2
}
