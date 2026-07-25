import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 spinner-badge:徽章内加载态 —— Spinner 作为前置(leading)元素表示进行中。
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
