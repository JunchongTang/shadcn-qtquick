import QtQuick
import Shadcn

/*!
    \qmltype ToggleGroupItem
    \inqmlmodule Shadcn
    \inherits Toggle
    \brief An item within a ToggleGroup.

    ToggleGroupItem reuses all of \l Toggle's styling and additionally inherits the
    parent \l ToggleGroup's \c variant and \c size, and participates in the group's
    single/multiple selection logic. \c enabled propagates automatically from a
    disabled group, so it needs no explicit handling.

    \sa ToggleGroup, Toggle
*/
Toggle {
    id: item

    /*!
        \qmlproperty string ToggleGroupItem::value
        Optional application-defined identifier for this item.
    */
    property string value: ""

    variant: (parent && parent.variant !== undefined) ? parent.variant : Toggle.Default
    size: (parent && parent.size !== undefined) ? parent.size : Toggle.Default

    onCheckedChanged: if (parent && parent._onItemToggled) parent._onItemToggled(item)
}
