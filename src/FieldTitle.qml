import QtQuick
import QtQuick.Layouts

// shadcn FieldTitle —— FieldContent 内的标题,带标签排版(text-xs/relaxed medium)。
// 与 FieldLabel 的区别:非 <label>,不绑定控件,用于选择卡/开关等的标题行。
Text {
    property bool invalid: false        // 随 Field.invalid 转破坏色

    Layout.fillWidth: true
    color: invalid ? Theme.destructive : Theme.foreground
    font.pixelSize: Theme.textXs
    font.weight: Font.Medium
    lineHeight: Theme.lineRelaxed
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    opacity: enabled ? 1.0 : 0.5
}
