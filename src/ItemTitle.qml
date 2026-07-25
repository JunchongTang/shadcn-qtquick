import QtQuick
import QtQuick.Layouts

/*!
    \qmltype ItemTitle
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief Title line of a \l ShadItem: text-xs, snug leading, medium weight,
    single line (line-clamp-1).

    The convenience \l text property renders a built-in title label; custom
    children (a coloured span, a badge, etc.) can be placed directly instead.
    Children are laid out horizontally with gap-2.
*/
RowLayout {
    id: title

    readonly property string itemSlot: "item-title"
    /*!
        \qmlproperty string ItemTitle::text
        Convenience title text. When empty the built-in label is hidden and only
        custom children show.
    */
    property string text: ""
    /*!
        \qmlproperty color ItemTitle::color
        Colour of the built-in title label.
    */
    property color color: Theme.foreground

    Layout.fillWidth: true
    spacing: Theme.space2   // gap-2

    Text {
        visible: title.text !== ""
        text: title.text
        color: title.color
        font.pixelSize: Theme.textXs
        font.weight: Font.Medium
        elide: Text.ElideRight       // line-clamp-1
        Layout.fillWidth: true
    }
}
