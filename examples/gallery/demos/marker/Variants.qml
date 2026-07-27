import QtQuick
import QtQuick.Layouts
import Shadcn

// Official marker-variants: default / separator / border, three layouts.
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
