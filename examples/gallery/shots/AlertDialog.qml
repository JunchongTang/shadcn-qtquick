import QtQuick
import Shadcn

Rectangle {
    color: Theme.background
    implicitWidth: 620
    implicitHeight: 360

    Button { anchors.centerIn: parent; text: qsTr("Show Dialog"); variant: Button.Outline }

    AlertDialog {
        id: dialog
        title: qsTr("Are you absolutely sure?")
        description: qsTr("This action cannot be undone. This will permanently delete your account and remove your data from our servers.")
        cancelText: qsTr("Cancel")
        actionText: qsTr("Continue")
    }

    Component.onCompleted: dialog.open()
}
