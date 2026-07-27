import QtQuick
import QtQuick.Controls
import Shadcn

// Horizontal two-pane: drag the 1px center handle to change the left/right ratio. SplitView.* are attached properties, so import QtQuick.Controls.
Resizable {
    width: 380
    height: 200
    orientation: Qt.Horizontal

    Item {
        SplitView.preferredWidth: 190
        SplitView.minimumWidth: 60
        Text {
            anchors.centerIn: parent
            text: qsTr("One")
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
            text: qsTr("Two")
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.DemiBold
        }
    }
}
