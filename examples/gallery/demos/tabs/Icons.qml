import QtQuick
import Shadcn

// 带图标的触发器:iconName 为左侧 Lucide 图标(size-3.5 = 14),与文本 gap-1.5。
Tabs {
    TabButton { iconName: "app-window"; text: qsTr("Preview") }
    TabButton { iconName: "code"; text: qsTr("Code") }
}
