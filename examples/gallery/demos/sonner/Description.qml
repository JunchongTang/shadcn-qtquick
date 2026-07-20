import QtQuick
import Shadcn

// 带描述的 toast:标题 + 次要说明文本(对标 sonner-description)。
Item {
    implicitWidth: 420
    implicitHeight: 200

    Button {
        anchors.centerIn: parent
        text: "Show Toast"
        variant: Button.Outline
        onClicked: area.show("Event has been created", {
            description: "Monday, January 3rd at 6:00pm"
        })
    }

    ToastArea { id: area; anchors.fill: parent }
}
