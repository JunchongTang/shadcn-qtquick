import QtQuick
import QtQuick.Controls
import Shadcn

// Horizontal two-pane: drag the 1px center handle to change the left/right ratio.
// The group draws no border of its own (like shadcn, where the border is a class
// on the group), so it's wrapped in a rounded, 1px-bordered box. SplitView.* are
// attached properties, so import QtQuick.Controls.
Rectangle {
    width: 380
    height: 200
    radius: Theme.radiusLg
    color: "transparent"
    border.width: 1
    border.color: Theme.border

    Resizable {
        anchors.fill: parent
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
}
