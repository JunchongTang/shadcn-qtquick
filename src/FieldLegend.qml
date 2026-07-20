import QtQuick
import QtQuick.Layouts

// shadcn FieldLegend —— FieldSet 的标题(font-medium)。
//   variant "legend"(默认):text-sm
//   variant "label"       :text-xs/relaxed(与标签同尺寸,适合嵌套 FieldSet)
Text {
    enum Variant { Legend, Label }

    property int variant: FieldLegend.Legend

    Layout.fillWidth: true
    color: Theme.foreground
    font.pixelSize: variant === FieldLegend.Label ? Theme.textXs : Theme.textSm
    font.weight: Font.Medium
    lineHeight: variant === FieldLegend.Label ? Theme.lineRelaxed : 1.0
    lineHeightMode: Text.ProportionalHeight
    wrapMode: Text.Wrap
    horizontalAlignment: Text.AlignLeft
}
