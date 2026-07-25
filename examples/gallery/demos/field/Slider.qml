import QtQuick
import QtQuick.Layouts
import Shadcn

// FieldTitle + FieldDescription + Slider(描述随取值联动)。
// 前端为双滑块区间 [200,800];本库 Slider 为单值,简化为单一预算上限。
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
