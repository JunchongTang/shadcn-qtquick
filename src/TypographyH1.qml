import QtQuick

// shadcn Typography h1 —— text-4xl(36) font-extrabold tracking-tight。
// tracking-tight = -0.025em → -0.9px @36。line-height 2.5rem(40) → 1.111。
Text {
    color: Theme.foreground
    font.family: Theme.fontHeading
    font.pixelSize: 36
    font.weight: Font.ExtraBold
    font.letterSpacing: -0.9
    lineHeight: 1.111
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
