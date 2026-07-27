import QtQuick
import QtQuick.Layouts
import Shadcn

// Official marker-separator: separator line with a centered label (date / section).
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
