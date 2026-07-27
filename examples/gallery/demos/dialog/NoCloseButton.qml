import QtQuick
import Shadcn

// No Close Button -- showCloseButton: false hides the top-right close button (matches dialog-no-close-button).
Button {
    text: qsTr("No Close Button")
    variant: Button.Outline
    onClicked: dialog.open()

    Dialog {
        id: dialog
        title: qsTr("No Close Button")
        description: qsTr("This dialog doesn't have a close button in the top-right corner.")
        showCloseButton: false
    }
}
