import QtQuick
import QtQuick.Controls
import Shadcn

// Vertical split: orientation=Qt.Vertical, the handle becomes a horizontal 1px divider.
Resizable {
    width: 340
    height: 220
    orientation: Qt.Vertical

    Item {
        SplitView.preferredHeight: 60
        SplitView.minimumHeight: 40
        Text {
            anchors.centerIn: parent
            text: qsTr("Header")
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.DemiBold
        }
    }
    Item {
        SplitView.fillHeight: true
        SplitView.minimumHeight: 40
        Text {
            anchors.centerIn: parent
            text: qsTr("Content")
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.DemiBold
        }
    }
}
