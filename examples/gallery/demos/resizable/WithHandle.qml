import QtQuick
import QtQuick.Controls
import Shadcn

// With handle: when withHandle=true the handle shows a bg-border grip block in
// its center, making it easier to discover it is draggable. The border lives on
// the enclosing box (the group itself is unframed).
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
}
