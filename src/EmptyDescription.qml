import QtQuick
import QtQuick.Layouts

// shadcn EmptyDescription(base-mira) —— 空状态描述文本。
// 对齐 .cn-empty-description:text-xs/relaxed text-muted-foreground;text-center。
Text {
    Layout.fillWidth: true
    color: Theme.mutedForeground
    font.pixelSize: Theme.textXs         // text-xs = 12
    lineHeight: Theme.lineRelaxed        // /relaxed = 1.625
    lineHeightMode: Text.ProportionalHeight
    horizontalAlignment: Text.AlignHCenter
    wrapMode: Text.Wrap
}
