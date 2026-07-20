import QtQuick
import Shadcn

// No Close Button —— showCloseButton: false 隐藏右上角关闭按钮(对标 dialog-no-close-button)。
Button {
    text: "No Close Button"
    variant: Button.Outline
    onClicked: dialog.open()

    Dialog {
        id: dialog
        title: qsTr("No Close Button")
        description: qsTr("This dialog doesn't have a close button in the top-right corner.")
        showCloseButton: false
    }
}
