import QtQuick
import Shadcn

// 官方 date-picker-demo:单选日期,outline 触发器(左 calendar 图标 + "Pick a date" 占位),
// 点击弹出月历,选日后回填格式化长日期并关闭。
DatePicker {
    id: picker
    width: 212                       // w-[212px]
    placeholder: qsTr("Pick a date")
}
