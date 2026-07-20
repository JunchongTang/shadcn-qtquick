import QtQuick

// shadcn Typography large —— text-lg(18) font-semibold。foreground。
// line-height 1.75rem(28) → 1.556。
Text {
    color: Theme.foreground
    font.family: Theme.fontSans
    font.pixelSize: Theme.textLg
    font.weight: Font.DemiBold
    lineHeight: 1.556
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
