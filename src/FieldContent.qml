import QtQuick
import QtQuick.Layouts

// shadcn FieldContent —— 标签与描述并排于控件旁时,把它们收拢为一列
// (flex flex-1 flex-col gap-0.5 leading-snug)。无描述时可省略。
ColumnLayout {
    Layout.fillWidth: true
    spacing: Theme.space0_5      // gap-0.5
}
