import QtQuick
import Shadcn

// 禁用项:enabled=false → 变暗(opacity 0.5)且不可点击/选中。
Tabs {
    TabButton { text: qsTr("Home") }
    TabButton { text: qsTr("Disabled"); enabled: false }
}
