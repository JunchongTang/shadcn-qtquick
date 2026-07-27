import QtQuick
import Shadcn

// Custom cell size (matches "Custom Cell Size": tuning --cell-size). Here cellSize=40 is used.
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
        cellSize: 40
        selectedDate: new Date()
    }
}
