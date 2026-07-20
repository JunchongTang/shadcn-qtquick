import QtQuick

// shadcn FieldDescription —— 字段辅助说明(muted)。对标 base-mira .cn-field-description
// (text-muted-foreground · text-xs/relaxed)。空文本时自动隐藏。
Text {
    color: Theme.mutedForeground
    font.pixelSize: Theme.textXs          // text-xs
    lineHeight: Theme.lineRelaxed         // leading-relaxed
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    visible: text !== ""
}
