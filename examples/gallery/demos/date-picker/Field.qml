import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 date-picker-basic:Field(label + 控件)包裹的日期选择器,宽 w-44、align="start"。
// 说明:库中暂无 Field/FieldLabel 组件,此处以 Label + DatePicker 垂直组合等价还原(gap-2)。
ColumnLayout {
    id: field
    width: 176                       // w-44
    spacing: Theme.space2            // Field gap ≈ gap-2

    Label {
        text: "Date"                 // FieldLabel
    }

    DatePicker {
        Layout.fillWidth: true
        placeholder: "Pick a date"
        align: Popover.Align.Start
    }
}
