import QtQuick

// shadcn Typography muted —— text-sm(14) text-muted-foreground。
// line-height 1.25rem(20) → 1.4286。
Text {
    color: Theme.mutedForeground
    font.family: Theme.fontSans
    font.pixelSize: Theme.textSm
    font.weight: Font.Normal
    lineHeight: 1.4286
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
