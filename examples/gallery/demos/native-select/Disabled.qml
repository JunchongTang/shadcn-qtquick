import QtQuick
import Shadcn

// 官方 native-select-disabled:整体禁用(opacity-50 + 不可交互)。
NativeSelect {
    width: 180
    enabled: false
    currentIndex: -1
    placeholder: "Disabled"
    model: ["Apple", "Banana", "Blueberry"]
}
