import QtQuick
import QtQuick.Layouts
import Shadcn

// Official marker-border: status row with a bottom border (separates the next line).
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
