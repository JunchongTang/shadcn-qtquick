import QtQuick
import QtQuick.Layouts

/*!
    \qmltype ItemSeparator
    \inqmlmodule Shadcn
    \inherits Item
    \brief Horizontal divider between two \l ShadItem rows inside an
    \l ItemGroup.

    A 1px horizontal \l Separator centred vertically, with my-2 breathing room
    (8px above and below).
*/
Item {
    readonly property string itemSlot: "item-separator"

    Layout.fillWidth: true
    implicitHeight: 1 + Theme.space2 * 2   // 1px line + my-2

    Separator {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        orientation: Separator.Horizontal
    }
}
