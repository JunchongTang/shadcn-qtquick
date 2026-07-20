import QtQuick
import Shadcn

Button {
    text: "Share Project"
    variant: Button.Outline
    onClicked: dialog.open()

    AlertDialog {
        id: dialog
        mediaIconName: "circle-fading-plus"
        title: qsTr("Share this project?")
        description: qsTr("Anyone with the link will be able to view and edit this project.")
        cancelText: qsTr("Cancel")
        actionText: qsTr("Share")
    }
}
