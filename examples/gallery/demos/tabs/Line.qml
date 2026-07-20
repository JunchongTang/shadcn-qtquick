import QtQuick
import Shadcn

// Line 变体:无 muted 底,激活项以底部 2px 前景色下划线标示。
Tabs {
    variant: Tabs.Line
    TabButton { text: "Overview" }
    TabButton { text: "Analytics" }
    TabButton { text: "Reports" }
}
