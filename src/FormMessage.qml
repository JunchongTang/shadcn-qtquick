import QtQuick

// shadcn FieldError —— 字段校验错误文本(destructive)。对标 base-mira .cn-field-error
// (text-destructive · text-xs/relaxed)。空文本时自动隐藏。
// 说明:官方错误来自 react-hook-form + zod;QML 无等价库,此处仅呈现使用方给出的文本。
Text {
    color: Theme.destructive
    font.pixelSize: Theme.textXs          // text-xs
    lineHeight: Theme.lineRelaxed         // leading-relaxed
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    visible: text !== ""
}
