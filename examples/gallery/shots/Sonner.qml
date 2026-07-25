import QtQuick
import Shadcn

Rectangle {
    color: Theme.background
    implicitWidth: 460
    implicitHeight: 240

    Button {
        anchors.centerIn: parent
        text: qsTr("Show Toast")
        variant: Button.Outline
    }

    ToastArea { id: area; anchors.fill: parent }

    Component.onCompleted: area.show(qsTr("Event has been created"), { description: qsTr("Sunday, December 03 at 9:00 AM") })
}
