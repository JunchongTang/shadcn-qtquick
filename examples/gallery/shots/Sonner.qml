import QtQuick
import Shadcn

Rectangle {
    color: Theme.background
    implicitWidth: 460
    implicitHeight: 240

    Button {
        anchors.centerIn: parent
        text: "Show Toast"
        variant: Button.Outline
    }

    ToastArea { id: area; anchors.fill: parent }

    Component.onCompleted: area.show("Event has been created", { description: "Sunday, December 03 at 9:00 AM" })
}
