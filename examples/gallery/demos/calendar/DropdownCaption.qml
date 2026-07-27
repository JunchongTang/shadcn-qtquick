import QtQuick
import Shadcn

// Month/year dropdown caption (matches calendar-caption: captionLayout="dropdown").
// The caption area uses two NativeSelects to switch month and year; still single-select mode.
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
