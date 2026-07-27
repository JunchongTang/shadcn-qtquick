import QtQuick
import QtQuick.Controls
import Shadcn

// Nested: put another vertical Resizable inside the right pane (framed=false to avoid a double border).
// The three panes One / Two / Three each resize independently; all handles show a grip.
Resizable {
    width: 400
    height: 220
    orientation: Qt.Horizontal
    withHandle: true

    Item {
        SplitView.preferredWidth: 200
        SplitView.minimumWidth: 80
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
        SplitView.minimumWidth: 80

        Resizable {
            anchors.fill: parent
            orientation: Qt.Vertical
            framed: false
            withHandle: true

            Item {
                SplitView.preferredHeight: 60
                SplitView.minimumHeight: 40
                Text {
                    anchors.centerIn: parent
                    text: qsTr("Two")
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
                    text: qsTr("Three")
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm
                    font.weight: Font.DemiBold
                }
            }
        }
    }
}
