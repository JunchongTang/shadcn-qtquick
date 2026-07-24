import QtQuick
import QtQuick.Layouts

/*!
    \qmltype CardFooter
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief Card action row (cn-card-footer): flex items-center.

    Actions are laid out horizontally and vertically centred. Horizontal insets
    come from the enclosing Card.
*/
RowLayout {
    Layout.fillWidth: true
    spacing: Theme.space2
}
