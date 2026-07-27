import QtQuick
import Shadcn

// Toast with description: title + secondary description text (matches sonner-description).
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
