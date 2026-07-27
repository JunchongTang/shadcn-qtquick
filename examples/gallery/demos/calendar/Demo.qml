import QtQuick
import Shadcn

// Basic single-select calendar, preselecting today; outer rounded-lg border (matches calendar-demo).
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
        selectedDate: new Date()
    }
}
