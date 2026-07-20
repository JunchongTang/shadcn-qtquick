import QtQuick

// shadcn InputGroupText —— addon 内的文本标注(cn-input-group-text)。
// text-muted-foreground、text-xs、font-medium(继承 addon 的字重)。放入 InputGroupAddon 内使用。
// 如需图标+文本组合,把 LucideIcon 与本组件并列放进同一 InputGroupAddon(addon 为横向布局)。
Text {
    color: Theme.mutedForeground
    font.pixelSize: Theme.textXs
    font.weight: Font.Medium
    font.family: Theme.fontSans
    verticalAlignment: Text.AlignVCenter
    textFormat: Text.PlainText
}
