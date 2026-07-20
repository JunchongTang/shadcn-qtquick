import QtQuick
import Shadcn

// 月/年下拉标题(对齐 calendar-caption:captionLayout="dropdown")。
// 标题区改用两个 NativeSelect 切换月份与年份;仍为单选模式。
Rectangle {
    implicitWidth: cal.implicitWidth
    implicitHeight: cal.implicitHeight
    radius: Theme.radiusLg
    color: Theme.background
    border.width: 1
    border.color: Theme.border

    Calendar {
        id: cal
        anchors.centerIn: parent
        mode: Calendar.Single
        captionLayout: Calendar.Dropdown
    }
}
