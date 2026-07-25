import QtQuick
import QtQuick.Controls
import Shadcn

// 水平两栏:拖拽中间 1px 手柄改变左右占比。SplitView.* 为附加属性,故需 import QtQuick.Controls。
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
