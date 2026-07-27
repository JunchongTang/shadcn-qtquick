import QtQuick
import QtQuick.Layouts
import Shadcn

// Official marker-demo: inline marker / status (spinner + shimmer) / separator / inline.
ColumnLayout {
    width: 320
    spacing: 32                     // gap-8

    Marker {
        iconName: "git-branch"
        text: qsTr("Switched to a new branch")
    }
    Marker {
        spinner: true               // role="status"
        shimmer: true
        text: qsTr("Thinking...")
    }
    Marker {
        variant: Marker.Separator
        text: qsTr("Conversation compacted")
    }
    Marker {
        iconName: "search"
        text: qsTr("Explored 4 files")
    }
}
