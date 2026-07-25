import QtQuick
import Shadcn

// 整个 Select 禁用(enabled:false → opacity 0.5,不可交互)。
// 单项禁用:model 条目加 { disabled: true }(见列表里的 Grapes)。
Select {
    width: 200
    enabled: false
    textRole: "text"
    currentIndex: -1
    placeholder: qsTr("Select a fruit")
    model: [
        { text: qsTr("Apple") },
        { text: qsTr("Banana") },
        { text: qsTr("Blueberry") },
        { text: qsTr("Grapes"), disabled: true },
        { text: qsTr("Pineapple") }
    ]
}
