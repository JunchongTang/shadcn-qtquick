import QtQuick
import Shadcn

// 基础单选月历,预选今天;外框 rounded-lg border(对齐 calendar-demo)。
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
