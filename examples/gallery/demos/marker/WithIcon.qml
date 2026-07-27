import QtQuick
import QtQuick.Layouts
import Shadcn

// Official marker-icon: MarkerIcon icon slot; the third uses flex-col (stacked) with the icon on top and content below.
ColumnLayout {
    width: 320
    spacing: 48                     // gap-12

    Marker {
        iconName: "git-branch"
        text: qsTr("Switched to a new branch")
    }
    Marker {
        variant: Marker.Separator
        iconName: "search"
        text: qsTr("Explored 4 files")
    }
    Marker {
        stacked: true               // className="flex-col"
        iconName: "book-open-check"
        text: qsTr("Syncing completed")
    }
}
