import QtQuick
import Shadcn

// 分组:model 中的 { header } 渲染为分组标题,{ separator: true } 渲染为分隔线。
Select {
    width: 200
    textRole: "text"
    currentIndex: -1
    placeholder: qsTr("Select a fruit")
    model: [
        { header: qsTr("Fruits") },
        { text: qsTr("Apple") },
        { text: qsTr("Banana") },
        { text: qsTr("Blueberry") },
        { separator: true },
        { header: qsTr("Vegetables") },
        { text: qsTr("Carrot") },
        { text: qsTr("Broccoli") },
        { text: qsTr("Spinach") }
    ]
}
