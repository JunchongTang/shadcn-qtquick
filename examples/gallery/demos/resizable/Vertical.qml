import QtQuick
import QtQuick.Controls
import Shadcn

// 垂直分栏:orientation=Qt.Vertical,手柄变为横向 1px 分隔线。
Resizable {
    width: 340
    height: 220
    orientation: Qt.Vertical

    Item {
        SplitView.preferredHeight: 60
        SplitView.minimumHeight: 40
        Text {
            anchors.centerIn: parent
            text: "Header"
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
            text: "Content"
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.weight: Font.DemiBold
        }
    }
}
