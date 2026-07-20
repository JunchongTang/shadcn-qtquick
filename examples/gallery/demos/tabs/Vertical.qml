import QtQuick
import Shadcn

// 竖排 Tabs:TabButton 纵向堆叠、文本左对齐,激活胶囊照常。
Tabs {
    vertical: true
    TabButton { text: "Account" }
    TabButton { text: "Password" }
    TabButton { text: "Notifications" }
}
