import QtQuick
import Shadcn

// Single-select calendar with no initial selection (matches calendar-basic: mode="single" + rounded-lg border).
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
    }
}
