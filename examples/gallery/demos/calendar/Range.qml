import QtQuick
import Shadcn

// 区间选择月历(对齐 calendar-range:mode="range")。先后点击两日选起止,
// 起止日为 primary 圆角药丸、中间日 muted 直角连接带。
// 简化:仅渲染单月(官方 numberOfMonths={2} 双月并排未实现),故预置区间落在同一月内。
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
        mode: Calendar.Range
        // 预置:当月 8 号 → 19 号。
        rangeStart: new Date((new Date()).getFullYear(), (new Date()).getMonth(), 8)
        rangeEnd: new Date((new Date()).getFullYear(), (new Date()).getMonth(), 19)
    }
}
