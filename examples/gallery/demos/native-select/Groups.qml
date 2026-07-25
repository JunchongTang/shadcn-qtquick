import QtQuick
import Shadcn

// 官方 native-select-groups:optgroup 分组 —— model 中的 { header } 渲染为分组标题(不可选)。
NativeSelect {
    width: 200
    textRole: "text"
    currentIndex: -1
    placeholder: qsTr("Select department")
    model: [
        { header: qsTr("Engineering") },
        { text: qsTr("Frontend") },
        { text: qsTr("Backend") },
        { text: qsTr("DevOps") },
        { header: qsTr("Sales") },
        { text: qsTr("Sales Rep") },
        { text: qsTr("Account Manager") },
        { text: qsTr("Sales Director") },
        { header: qsTr("Operations") },
        { text: qsTr("Customer Support") },
        { text: qsTr("Product Manager") },
        { text: qsTr("Operations Manager") }
    ]
}
