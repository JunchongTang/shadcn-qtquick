import QtQuick
import QtQuick.Layouts
import Shadcn

// Swipe handle: a bottom drawer that shows the centered grab handle (showHandle).
Button {
    text: qsTr("Open Drawer")
    variant: Button.Outline
    onClicked: drawer.open()

    Drawer {
        id: drawer
        side: "bottom"
        showHandle: true
        title: qsTr("Swipe handle")
        description: qsTr("Drag the handle at the top to dismiss, or use the button below.")

        footer: Button {
            text: qsTr("Close")
            variant: Button.Outline
            onClicked: drawer.close()
        }
    }
}
