import QtQuick
import QtQuick.Layouts
import Shadcn

// Official marker-status: in-progress marker with role="status" + Spinner (includes a separator variant).
ColumnLayout {
    width: 320
    spacing: 32                     // gap-8

    Marker {
        spinner: true
        text: qsTr("Compacting conversation")
    }
    Marker {
        variant: Marker.Separator
        spinner: true
        text: qsTr("Running tests")
    }
}
