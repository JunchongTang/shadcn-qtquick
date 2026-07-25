import QtQuick
import Shadcn

// 基础 toast:点击按钮弹出一条无图标的通知(sonner-demo 的最简形态)。
Item {
    implicitWidth: 420
    implicitHeight: 200

    Button {
        anchors.centerIn: parent
        text: qsTr("Show Toast")
        variant: Button.Outline
        onClicked: area.show(qsTr("Event has been created"))
    }

    ToastArea { id: area; anchors.fill: parent }
}
