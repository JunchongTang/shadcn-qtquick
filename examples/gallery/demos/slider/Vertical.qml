import QtQuick
import QtQuick.Layouts
import Shadcn

// orientation="vertical" 双列,className="h-40"(160);gap-6(24)。
RowLayout {
    spacing: 24

    Slider {
        Layout.preferredHeight: 160
        orientation: Qt.Vertical
        from: 0
        to: 100
        value: 50
        stepSize: 1
    }
    Slider {
        Layout.preferredHeight: 160
        orientation: Qt.Vertical
        from: 0
        to: 100
        value: 25
        stepSize: 1
    }
}
