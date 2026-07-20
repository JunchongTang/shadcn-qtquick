import QtQuick

// ToggleGroup 的子项 —— 复用 Toggle 的全部样式,额外接入分组的 variant/size 传播
// 与单选/多选逻辑。variant/size 默认继承父 ToggleGroup;value 供业务标识用。
// enabled 由 QML 自动从父级(禁用的分组)向下继承,无需显式处理。
Toggle {
    id: item

    property string value: ""

    variant: (parent && parent.variant !== undefined) ? parent.variant : Toggle.Default
    size: (parent && parent.size !== undefined) ? parent.size : Toggle.Default

    onCheckedChanged: if (parent && parent._onItemToggled) parent._onItemToggled(item)
}
