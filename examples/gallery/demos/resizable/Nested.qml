import QtQuick
import QtQuick.Controls
import Shadcn

// Nested: put another vertical Resizable inside the right pane. Only the outer
// group gets a border (the enclosing box); the inner group is unframed by
// nature, so no double border. The three panes One / Two / Three each resize
// independently; all handles show a grip.
Rectangle {
    width: 400
    height: 220
    radius: Theme.radiusLg
    color: "transparent"
    border.width: 1
    border.color: Theme.border

    Resizable {
        anchors.fill: parent
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
}
