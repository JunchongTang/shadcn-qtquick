import QtQuick
import Shadcn

// Official date-picker-range: outline trigger (left calendar icon + "start - end" text),
// clicking opens a two-month Range calendar; picking start and end fills the formatted range and closes.
// Preset range matches the official from + addDays(20).
DateRangePicker {
    id: picker
    width: 256
    align: Popover.Align.Start
    // Preset: current year 1/20 → 2/9.
    rangeStart: new Date((new Date()).getFullYear(), 0, 20)
    rangeEnd: new Date((new Date()).getFullYear(), 1, 9)
}
