import QtQuick
import Shadcn

// 官方 date-picker-range:outline 触发器(左 calendar 图标 + "起 - 止" 文本),
// 点击弹出双月 Range 月历;选定起止后回填格式化区间并关闭。
// 预置区间对标官方 from + addDays(20)。
DateRangePicker {
    id: picker
    width: 256
    align: Popover.Align.Start
    // 预置:当年 1/20 → 2/9。
    rangeStart: new Date((new Date()).getFullYear(), 0, 20)
    rangeEnd: new Date((new Date()).getFullYear(), 1, 9)
}
