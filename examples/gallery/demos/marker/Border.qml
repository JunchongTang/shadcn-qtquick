import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 marker-border:带底部边框的状态行(分隔下一行)。
ColumnLayout {
    width: 320
    spacing: 12                     // gap-3

    Marker {
        variant: Marker.Border
        iconName: "git-branch"
        text: qsTr("Switched to release-candidate")
    }
    Marker {
        variant: Marker.Border
        iconName: "search"
        text: qsTr("Reviewed 8 related files")
    }
    Marker {
        variant: Marker.Border
        iconName: "file-text"
        text: qsTr("Opened implementation notes")
    }
}
