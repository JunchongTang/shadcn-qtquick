import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 marker-demo:内联标记 / 状态(spinner + shimmer)/ 分隔 / 内联。
ColumnLayout {
    width: 320
    spacing: 32                     // gap-8

    Marker {
        iconName: "git-branch"
        text: "Switched to a new branch"
    }
    Marker {
        spinner: true               // role="status"
        shimmer: true
        text: "Thinking..."
    }
    Marker {
        variant: Marker.Separator
        text: "Conversation compacted"
    }
    Marker {
        iconName: "search"
        text: "Explored 4 files"
    }
}
