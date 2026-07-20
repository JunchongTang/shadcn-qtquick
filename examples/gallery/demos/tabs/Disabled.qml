import QtQuick
import Shadcn

// 禁用项:enabled=false → 变暗(opacity 0.5)且不可点击/选中。
Tabs {
    TabButton { text: "Home" }
    TabButton { text: "Disabled"; enabled: false }
}
