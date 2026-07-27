import QtQuick
import Shadcn

// Basic toast: clicking the button pops an icon-less notification (simplest form of sonner-demo).
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
