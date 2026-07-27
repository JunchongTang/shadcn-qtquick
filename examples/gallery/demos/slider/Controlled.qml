import QtQuick
import QtQuick.Layouts
import Shadcn

// Controlled: label + live value display, value two-way bound to the slider.
// Official slider-controlled uses a two-value range; single-value Slider can't cover a range, so demo the controlled mode with a single value here.
ColumnLayout {
    width: 320                  // max-w-xs
    spacing: 12

    RowLayout {
        Layout.fillWidth: true
        Label { text: qsTr("Temperature") }
        Item { Layout.fillWidth: true }
        Text {
            text: slider.value.toFixed(0)
            color: Theme.mutedForeground
            font.pixelSize: Theme.textSm
        }
    }

    Slider {
        id: slider
        Layout.fillWidth: true
        from: 0
        to: 100
        value: 30
        stepSize: 1
    }
}
