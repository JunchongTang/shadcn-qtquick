import QtQuick
import QtQuick.Controls
import Shadcn

// With handle: when withHandle=true the handle shows a bg-border grip block in its center, making it easier to discover it is draggable.
Resizable {
    width: 380
    height: 200
    orientation: Qt.Horizontal
    withHandle: true

    Item {
        SplitView.preferredWidth: 110
        SplitView.minimumWidth: 60
        Text {
            anchors.centerIn: parent
            text: qsTr("Sidebar")
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.DemiBold
        }
    }
    Item {
        SplitView.fillWidth: true
        SplitView.minimumWidth: 60
        Text {
            anchors.centerIn: parent
            text: qsTr("Content")
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.DemiBold
        }
    }
}
