import QtQuick.Layouts

/*!
    \qmltype ItemFooter
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief Full-width footer row of a \l ShadItem, placed below the content.

    Spans the whole item (basis-full), justified with gap-2. The parent
    \l ShadItem migrates it into the footer zone, pinned to the bottom.
*/
RowLayout {
    readonly property string itemSlot: "item-footer"

    Layout.fillWidth: true
    spacing: Theme.space2   // gap-2
}
