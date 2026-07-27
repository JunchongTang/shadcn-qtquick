import QtQuick
import QtQuick.Layouts
import Shadcn

// Official slider-controlled: controlled range. value={[0.3, 0.7]} min={0} max={1} step={0.1}
// label + live value display (two values joined with ", "), value two-way bound to the range slider.
ColumnLayout {
    width: 320                  // max-w-xs
    spacing: 12

    RowLayout {
        Layout.fillWidth: true
        Label { text: qsTr("Temperature") }
        Item { Layout.fillWidth: true }
        Text {
            text: slider.first.value.toFixed(1) + ", " + slider.second.value.toFixed(1)
            color: Theme.mutedForeground
            font.pixelSize: Theme.textSm
        }
    }

    RangeSlider {
        id: slider
        Layout.fillWidth: true
        from: 0
        to: 1
        stepSize: 0.1
        first.value: 0.3
        second.value: 0.7
    }
}
