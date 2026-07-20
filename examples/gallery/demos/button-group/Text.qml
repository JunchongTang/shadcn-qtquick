import QtQuick
import Shadcn

// 官方 API 示例(ButtonGroupText):在组内展示一段文本(bg-muted 药丸),与 Input 相接。
ButtonGroup {
    ButtonGroupText { text: "Currency" }
    Input {
        width: 200
        placeholderText: "Type something here..."
    }
}
