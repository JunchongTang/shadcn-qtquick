import QtQuick
import QtQuick.Controls
import Shadcn

// 嵌套:右侧面板内再放一个垂直 Resizable(framed=false,避免双重外框)。
// 三块 One / Two / Three 均可独立拖拽,所有手柄带抓手。
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
