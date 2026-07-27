import QtQuick
import QtQuick.Layouts
import Shadcn

// FieldTitle + FieldDescription + Slider (description updates with the value).
// The web uses a dual-handle range [200,800]; this library's Slider is single-value, simplified to a single budget cap.
Field {
    id: f
    width: 280        // max-w-xs

    FieldTitle { text: qsTr("Price Range") }
    FieldDescription {
        text: qsTr("Set your budget up to $") + Math.round(budget.value) + "."
    }
    Slider {
        id: budget
        Layout.fillWidth: true
        Layout.topMargin: Theme.space2   // mt-2
        from: 0
        to: 1000
        value: 800
        stepSize: 10
    }
}
