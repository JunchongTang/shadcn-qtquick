import QtQuick
import QtQuick.Layouts

// shadcn ItemGroup —— 纵向堆叠多个 Item(与 ItemSeparator)。间距随内部 Item 尺寸自适应:
// 含 xs → gap-2(8);含 sm → gap-2.5(10);否则 gap-4(16)。
ColumnLayout {
    id: group

    readonly property string itemSlot: "item-group"

    Layout.fillWidth: true
    spacing: 16   // gap-4 默认;完成后据子项尺寸调整

    Component.onCompleted: _computeSpacing()
    onChildrenChanged: Qt.callLater(_computeSpacing)

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
