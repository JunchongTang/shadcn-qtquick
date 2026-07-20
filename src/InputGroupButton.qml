import QtQuick

// shadcn InputGroupButton —— addon 内的小按钮(cn-input-group-button)。
// 默认 ghost、xs 尺寸;基于库内 Button,复用 variant/图标/焦点环/hover。
// 四档尺寸映射到 Button 尺寸(mira 数值):
//   KindXs   → Button.Xs      h20 · 文本
//   KindSm   → Button.Sm      h24 · 文本
//   KindIconXs → Button.IconSm 24×24 方形图标(CSS size-6)
//   KindIconSm → Button.Icon   28×28 方形图标(CSS size-7)
Button {
    id: btn

    enum Kind { KindXs, KindSm, KindIconXs, KindIconSm }

    property int kind: InputGroupButton.KindXs
    readonly property bool _igButton: true      // addon 据此对按钮做贴边负边距

    variant: Button.Ghost
    size: {
        switch (kind) {
        case InputGroupButton.KindSm:     return Button.Sm
        case InputGroupButton.KindIconXs: return Button.IconSm
        case InputGroupButton.KindIconSm: return Button.Icon
        default:                          return Button.Xs
        }
    }
}
