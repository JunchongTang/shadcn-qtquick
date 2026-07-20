import QtQuick

// shadcn Typography p —— leading-7(28px 行高)。正文 16px foreground。
// 段间距 mt-6(24)由外层布局负责,此处只定义排版本身。
Text {
    color: Theme.foreground
    font.family: Theme.fontSans
    font.pixelSize: Theme.textBase
    font.weight: Font.Normal
    lineHeight: 1.75            // leading-7 = 28 / 16
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    textFormat: Text.PlainText
}
