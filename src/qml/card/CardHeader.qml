import QtQuick
import QtQuick.Layouts

/*!
    \qmltype CardHeader
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief Card title region (cn-card-header): gap-1 vertical stack.

    Stacks CardTitle / CardDescription with a 4px gap. Horizontal insets come
    from the enclosing Card.

    \note The official grid layout with a trailing CardAction column is not
    modelled here.
*/
ColumnLayout {
    Layout.fillWidth: true
    spacing: Theme.space1
}
