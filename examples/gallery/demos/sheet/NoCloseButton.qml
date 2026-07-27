import QtQuick
import QtQuick.Layouts
import Shadcn

// Official sheet-no-close-button: showCloseButton: false hides the top-right close; click outside to close.
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
