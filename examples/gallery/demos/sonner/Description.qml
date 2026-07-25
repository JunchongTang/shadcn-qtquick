import QtQuick
import Shadcn

// 带描述的 toast:标题 + 次要说明文本(对标 sonner-description)。
Item {
    implicitWidth: 420
    implicitHeight: 200

    Button {
        anchors.centerIn: parent
        text: qsTr("Show Toast")
        variant: Button.Outline
        onClicked: area.show(qsTr("Event has been created"), {
            description: qsTr("Monday, January 3rd at 6:00pm")
        })
    }

    ToastArea { id: area; anchors.fill: parent }
}
