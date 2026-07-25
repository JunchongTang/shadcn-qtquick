import QtQuick
import Shadcn

// 官方 native-select-demo:占位 "Select status" + 状态选项。
NativeSelect {
    width: 180
    currentIndex: -1
    placeholder: qsTr("Select status")
    model: [qsTr("Todo"), qsTr("In Progress"), qsTr("Done"), qsTr("Cancelled")]
}
