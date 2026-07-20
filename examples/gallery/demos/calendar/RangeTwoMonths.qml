import QtQuick
import Shadcn

// 双月区间月历(对齐 calendar-range:mode="range" + numberOfMonths={2})。
// 两月并排、共享一套上/下月导航;区间以绝对日期比较,故跨月高亮连续:
// 起止日为 primary 圆角药丸,中间日(含月末/月初外月补格)以 muted 直角连接带贯通。
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
        numberOfMonths: 2
        // 首月 = 当年 1 月;预置跨月区间 1/12 → 2/11(对标官方 from + addDays(30))。
        displayMonth: new Date((new Date()).getFullYear(), 0, 1)
        rangeStart: new Date((new Date()).getFullYear(), 0, 12)
        rangeEnd: new Date((new Date()).getFullYear(), 1, 11)
    }
}
