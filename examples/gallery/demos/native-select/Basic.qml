import QtQuick
import Shadcn

// 官方 native-select-demo:占位 "Select status" + 状态选项。
NativeSelect {
    width: 180
    currentIndex: -1
    placeholder: "Select status"
    model: ["Todo", "In Progress", "Done", "Cancelled"]
}
