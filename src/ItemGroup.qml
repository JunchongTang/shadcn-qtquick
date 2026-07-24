import QtQuick
import QtQuick.Layouts

/*!
    \qmltype ItemGroup
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief Vertical stack of \l ShadItem (and \l ItemSeparator) rows.

    Spacing adapts to the size of the contained items: any xs item yields
    gap-2 (8), otherwise any sm item yields gap-2.5 (10), otherwise gap-4 (16).
    The spacing is recomputed whenever the children change.
*/
ColumnLayout {
    id: group

    readonly property string itemSlot: "item-group"

    Layout.fillWidth: true
    spacing: 16   // gap-4 default; adjusted from child sizes once completed

    Component.onCompleted: _computeSpacing()
    onChildrenChanged: Qt.callLater(_computeSpacing)

    // Derive stack spacing from the smallest contained item size.
    function _computeSpacing() {
        var hasSm = false
        var hasXs = false
        for (var i = 0; i < children.length; i++) {
            var c = children[i]
            if (!c || c.itemSlot !== "item" || c.size === undefined)
                continue
            if (c.size === ShadItem.Xs) hasXs = true
            else if (c.size === ShadItem.Sm) hasSm = true
        }
        spacing = hasXs ? 8 : hasSm ? 10 : 16
    }
}
