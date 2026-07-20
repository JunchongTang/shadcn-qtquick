import QtQuick
import QtQuick.Layouts
import Shadcn

// 受控:label + 实时值显示,值双向绑定到滑块。
// 官方 slider-controlled 用的是双值区间;单值 Slider 无法覆盖区间,这里以单值演示受控模式。
ColumnLayout {
    width: 320                  // max-w-xs
    spacing: 12

    RowLayout {
        Layout.fillWidth: true
        Label { text: "Temperature" }
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
