import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 sheet-no-close-button:showCloseButton: false 隐藏右上角关闭,点击外部关闭。
Button {
    text: qsTr("Open Sheet")
    variant: Button.Outline
    onClicked: sheet.open()

    Sheet {
        id: sheet
        showCloseButton: false
        title: qsTr("No Close Button")
        description: qsTr("This sheet doesn't have a close button in the top-right corner. "
                        + "Click outside to close.")
    }
}
