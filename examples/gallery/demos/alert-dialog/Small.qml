import QtQuick
import Shadcn

Button {
    text: qsTr("Show Dialog")
    variant: Button.Outline
    onClicked: dialog.open()

    AlertDialog {
        id: dialog
        size: AlertDialog.Sm
        title: qsTr("Allow accessory to connect?")
        description: qsTr("Do you want to allow the USB accessory to connect to this device?")
        cancelText: qsTr("Don't allow")
        actionText: qsTr("Allow")
    }
}
