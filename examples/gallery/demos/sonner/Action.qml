import QtQuick
import Shadcn

// Toast with action: description + trailing action button (Undo); triggering the action pops a confirmation (matches sonner-demo).
Item {
    implicitWidth: 420
    implicitHeight: 200

    Button {
        anchors.centerIn: parent
        text: qsTr("Show Toast")
        variant: Button.Outline
        onClicked: area.show(qsTr("Event has been created"), {
            description: qsTr("Sunday, December 03, 2023 at 9:00 AM"),
            actionText: qsTr("Undo")
        })
    }

    ToastArea {
        id: area
        anchors.fill: parent
        onActionTriggered: (uid) => area.success(qsTr("Event has been reverted"))
    }
}
