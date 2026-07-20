import QtQuick
import QtQuick.Layouts

// shadcn EmptyTitle(base-mira) —— 空状态标题。
// 对齐 .cn-empty-title:text-sm font-medium tracking-tight(+ cn-font-heading);text-center。
Text {
    Layout.fillWidth: true
    color: Theme.foreground
    font.family: Theme.fontHeading
    font.pixelSize: Theme.textSm         // text-sm = 14
    font.weight: Font.Medium
    font.letterSpacing: -0.35            // tracking-tight ≈ -0.025em × 14
    horizontalAlignment: Text.AlignHCenter
    wrapMode: Text.Wrap
}
