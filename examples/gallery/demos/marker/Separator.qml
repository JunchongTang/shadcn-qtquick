import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 marker-separator:带居中标签的分隔线(日期 / 分节)。
ColumnLayout {
    width: 320
    spacing: 32                     // gap-8

    Marker {
        variant: Marker.Separator
        text: qsTr("Today")
    }
    Marker {
        variant: Marker.Separator
        text: qsTr("Worked for 42s")
    }
    Marker {
        variant: Marker.Separator
        text: qsTr("Conversation compacted")
    }
}
