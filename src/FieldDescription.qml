import QtQuick
import QtQuick.Layouts

// shadcn FieldDescription —— 辅助说明文字(text-muted-foreground text-xs/relaxed)。
Text {
    property bool invalid: false        // 随 Field.invalid 转破坏色

    Layout.fillWidth: true
    color: invalid ? Theme.destructive : Theme.mutedForeground
    font.pixelSize: Theme.textXs
    lineHeight: Theme.lineRelaxed
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    horizontalAlignment: Text.AlignLeft
}
