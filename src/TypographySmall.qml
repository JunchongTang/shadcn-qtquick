import QtQuick

// shadcn Typography small —— text-sm(14) font-medium leading-none。foreground。
Text {
    color: Theme.foreground
    font.family: Theme.fontSans
    font.pixelSize: Theme.textSm
    font.weight: Font.Medium
    lineHeight: 1.0            // leading-none
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
