import QtQuick
import QtQuick.Controls
import Shadcn

// Vertical split: orientation=Qt.Vertical, the handle becomes a horizontal 1px
// divider. The border lives on the enclosing box (the group itself is unframed).
Rectangle {
    width: 340
    height: 220
    radius: Theme.radiusLg
    color: "transparent"
    border.width: 1
    border.color: Theme.border

    Resizable {
        anchors.fill: parent
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
}
