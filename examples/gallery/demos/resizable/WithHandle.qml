import QtQuick
import QtQuick.Controls
import Shadcn

// 带抓手:withHandle=true 时手柄中央显示 bg-border 抓手小块,更易发现可拖拽。
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
