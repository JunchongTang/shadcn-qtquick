import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 marker-demo:内联标记 / 状态(spinner + shimmer)/ 分隔 / 内联。
ColumnLayout {
    width: 320
    spacing: 32                     // gap-8

    Marker {
        iconName: "git-branch"
        text: qsTr("Switched to a new branch")
    }
    Marker {
        spinner: true               // role="status"
        shimmer: true
        text: qsTr("Thinking...")
    }
    Marker {
        variant: Marker.Separator
        text: qsTr("Conversation compacted")
    }
    Marker {
        iconName: "search"
        text: qsTr("Explored 4 files")
    }
}
