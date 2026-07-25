import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 marker-status:role="status" + Spinner 的进行中标记(含 separator 变体)。
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
