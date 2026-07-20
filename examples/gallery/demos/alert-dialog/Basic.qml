import QtQuick
import Shadcn

Button {
    text: "Show Dialog"
    variant: Button.Outline
    onClicked: dialog.open()

    AlertDialog {
        id: dialog
        title: qsTr("Are you absolutely sure?")
        description: qsTr("This action cannot be undone. This will permanently delete your account and remove your data from our servers.")
        cancelText: qsTr("Cancel")
        actionText: qsTr("Continue")
    }
}
