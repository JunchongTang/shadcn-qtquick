import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 marker-variants:default / separator / border 三种布局。
ColumnLayout {
    width: 320
    spacing: 32                     // gap-8

    Marker {
        text: qsTr("A default marker for inline notes.")
    }
    Marker {
        variant: Marker.Separator
        text: qsTr("A separator marker")
    }
    Marker {
        variant: Marker.Border
        text: qsTr("A border marker for row boundaries.")
    }
}
