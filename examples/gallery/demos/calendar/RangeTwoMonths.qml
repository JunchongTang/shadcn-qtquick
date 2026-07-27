import QtQuick
import Shadcn

// Two-month range calendar (matches calendar-range: mode="range" + numberOfMonths={2}).
// Two months side by side, sharing one prev/next-month navigation; the range is compared by absolute date, so cross-month highlight is continuous:
// start/end days are primary rounded pills, middle days (including month-end/start outside-month fill cells) run through as a muted square-corner connecting band.
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
        // First month = January of the current year; preset cross-month range 1/12 -> 2/11 (matches official from + addDays(30)).
        displayMonth: new Date((new Date()).getFullYear(), 0, 1)
        rangeStart: new Date((new Date()).getFullYear(), 0, 12)
        rangeEnd: new Date((new Date()).getFullYear(), 1, 11)
    }
}
