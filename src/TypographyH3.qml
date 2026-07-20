import QtQuick

// shadcn Typography h3 —— text-2xl(24) font-semibold tracking-tight。
// tracking-tight -0.025em → -0.6px @24。line-height 2rem(32) → 1.333。
Text {
    color: Theme.foreground
    font.family: Theme.fontHeading
    font.pixelSize: 24
    font.weight: Font.DemiBold
    font.letterSpacing: -0.6
    lineHeight: 1.333
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
