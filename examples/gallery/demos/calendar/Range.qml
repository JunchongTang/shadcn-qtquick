import QtQuick
import Shadcn

// Range-select calendar (matches calendar-range: mode="range"). Click two days in turn to pick start/end;
// start/end days are primary rounded pills, middle days are a muted square-corner connecting band.
// Simplification: renders a single month only (official numberOfMonths={2} side-by-side not implemented), so the preset range stays within one month.
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
        // Preset: 8th -> 19th of the current month.
        rangeStart: new Date((new Date()).getFullYear(), (new Date()).getMonth(), 8)
        rangeEnd: new Date((new Date()).getFullYear(), (new Date()).getMonth(), 19)
    }
}
