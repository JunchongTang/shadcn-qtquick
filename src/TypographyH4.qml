import QtQuick

// shadcn Typography h4 —— text-xl(20) font-semibold tracking-tight。
// tracking-tight -0.025em → -0.5px @20。line-height 1.75rem(28) → 1.4。
Text {
    color: Theme.foreground
    font.family: Theme.fontHeading
    font.pixelSize: 20
    font.weight: Font.DemiBold
    font.letterSpacing: -0.5
    lineHeight: 1.4
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
