import QtQuick

// shadcn Typography lead —— text-xl(20) text-muted-foreground。引言段。
// line-height 1.75rem(28) → 1.4。
Text {
    color: Theme.mutedForeground
    font.family: Theme.fontSans
    font.pixelSize: 20
    font.weight: Font.Normal
    lineHeight: 1.4
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
