import QtQuick
import QtQuick.Layouts
import Shadcn

// Official spinner-badge: loading state inside a badge -- Spinner as leading element indicates in-progress.
RowLayout {
    spacing: Theme.space4                  // gap-4

    Badge {
        id: syncing
        text: qsTr("Syncing")
        leading: Spinner { size: 10; color: syncing.fgColor }
    }
    Badge {
        id: updating
        text: qsTr("Updating")
        variant: Badge.Secondary
        leading: Spinner { size: 10; color: updating.fgColor }
    }
    Badge {
        id: processing
        text: qsTr("Processing")
        variant: Badge.Outline
        leading: Spinner { size: 10; color: processing.fgColor }
    }
}
