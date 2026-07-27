import QtQuick
import Shadcn

// Official date-picker-demo: single-date selection, outline trigger (left calendar icon + "Pick a date" placeholder),
// clicking opens the month calendar; picking a day fills the formatted long date and closes.
DatePicker {
    id: picker
    width: 212                       // w-[212px]
    placeholder: qsTr("Pick a date")
}
