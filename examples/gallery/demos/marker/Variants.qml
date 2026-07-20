import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 marker-variants:default / separator / border 三种布局。
ColumnLayout {
    width: 320
    spacing: 32                     // gap-8

    Marker {
        text: "A default marker for inline notes."
    }
    Marker {
        variant: Marker.Separator
        text: "A separator marker"
    }
    Marker {
        variant: Marker.Border
        text: "A border marker for row boundaries."
    }
}
