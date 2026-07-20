import QtQuick
import Shadcn

// 自定义单元格尺寸(对齐 "Custom Cell Size":调 --cell-size)。这里用 cellSize=40。
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
