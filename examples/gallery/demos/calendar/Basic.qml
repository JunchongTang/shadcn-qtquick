import QtQuick
import Shadcn

// 无初始选择的单选月历(对齐 calendar-basic:mode="single" + rounded-lg border)。
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
