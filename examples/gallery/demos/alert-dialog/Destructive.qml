import QtQuick
import Shadcn

Button {
    text: "Delete Chat"
    variant: Button.Destructive
    onClicked: dialog.open()

    AlertDialog {
        id: dialog
        size: AlertDialog.Sm
        mediaIconName: "trash-2"
        mediaDestructive: true
        title: qsTr("Delete chat?")
        description: qsTr("This will permanently delete this chat conversation and any memories saved during this chat.")
        cancelText: qsTr("Cancel")
        actionText: qsTr("Delete")
        actionVariant: Button.Destructive
    }
}
