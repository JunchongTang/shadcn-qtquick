import QtQuick
import Shadcn

// 官方 native-select-invalid:aria-invalid → 破坏色边框 + 破坏色环。
NativeSelect {
    width: 180
    invalid: true
    currentIndex: -1
    placeholder: "Error state"
    model: ["Apple", "Banana", "Blueberry"]
}
