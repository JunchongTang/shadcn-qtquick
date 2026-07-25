import QtQuick.Layouts

/*!
    \qmltype ItemActions
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief Trailing action slot of a \l ShadItem: buttons, icons, etc.

    Holds one or more action controls with gap-2, vertically centred. It does
    not stretch, so the neighbouring \l ItemContent pushes it to the right edge
    of the main row.
*/
RowLayout {
    readonly property string itemSlot: "item-actions"

    spacing: Theme.space2   // gap-2
    Layout.alignment: Qt.AlignVCenter
}
