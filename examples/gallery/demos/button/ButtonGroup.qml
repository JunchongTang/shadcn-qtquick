import QtQuick
import QtQuick.Layouts
import Shadcn

// 多个 ButtonGroup 之间留 gap-2;组内相邻 Button 首尾相接。
RowLayout {
    spacing: 8

    ButtonGroup {
        Button { variant: Button.Outline; size: Button.Icon; iconName: "arrow-left" }
    }
    ButtonGroup {
        Button { variant: Button.Outline; text: "Archive" }
        Button { variant: Button.Outline; text: "Report" }
    }
    ButtonGroup {
        Button { variant: Button.Outline; text: "Snooze" }
        Button { variant: Button.Outline; size: Button.Icon; iconName: "more-horizontal" }
    }
}
