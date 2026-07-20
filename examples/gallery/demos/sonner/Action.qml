import QtQuick
import Shadcn

// 带动作的 toast:描述 + 右侧动作按钮(Undo),点击动作后再弹一条确认(对标 sonner-demo)。
Item {
    implicitWidth: 420
    implicitHeight: 200

    Button {
        anchors.centerIn: parent
        text: "Show Toast"
        variant: Button.Outline
        onClicked: area.show("Event has been created", {
            description: "Sunday, December 03, 2023 at 9:00 AM",
            actionText: "Undo"
        })
    }

    ToastArea {
        id: area
        anchors.fill: parent
        onActionTriggered: (uid) => area.success("Event has been reverted")
    }
}
