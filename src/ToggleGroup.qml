import QtQuick
import QtQuick.Layouts

// shadcn Toggle Group(base-mira) —— 一组两态按钮。子项用 ToggleGroupItem。
// variant/size 由分组统一向下传播;multiple 决定单选(互斥)还是多选。
// spacing 为 shadcn 间距单位(× 4 = px;默认 2 → 8px 间距,自 2026-05-17 起默认值由 0 改为 2)。
// orientation:Horizontal(单行)/Vertical(单列)。分组 disabled 会自动向下禁用子项。
GridLayout {
    id: group

    enum Variant { Default, Outline }
    enum Size { Sm, Default, Lg }
    enum Orientation { Horizontal, Vertical }

    property int variant: ToggleGroup.Default
    property int size: ToggleGroup.Default
    property int spacing: 2                       // shadcn 单位(× 4 得 px)
    property int orientation: ToggleGroup.Horizontal
    property bool multiple: false                 // false → 单选互斥

    flow: orientation === ToggleGroup.Vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
    rows: orientation === ToggleGroup.Vertical ? -1 : 1
    columns: orientation === ToggleGroup.Vertical ? 1 : -1
    rowSpacing: spacing * 4
    columnSpacing: spacing * 4

    // 单选互斥:某项被选中时,取消其余项。多选模式不处理。
    function _onItemToggled(item) {
        if (multiple || !item.checked)
            return
        for (var i = 0; i < children.length; i++) {
            var c = children[i]
            if (c !== item && c.checkable === true && c.checked)
                c.checked = false
        }
    }
}
