import QtQuick
import QtQuick.Layouts
import Shadcn

// Official marker-shimmer: MarkerContent with a shimmer glow (streaming text).
// Approximation note: QML has no background-clip:text sweep, so shimmer is approximated with an opacity pulse (see Marker.qml).
ColumnLayout {
    width: 320
    spacing: 32                     // gap-8

    Marker {
        shimmer: true
        text: qsTr("Thinking...")
    }
    Marker {
        variant: Marker.Separator
        shimmer: true
        text: qsTr("Reading 4 files")
    }
}
