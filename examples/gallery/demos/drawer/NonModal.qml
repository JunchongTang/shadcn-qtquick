import QtQuick
import QtQuick.Layouts
import Shadcn

// Non-modal: the drawer does not dim or block the rest of the page, so the content
// behind stays interactive while it is open.
Button {
    text: qsTr("Open Drawer")
    variant: Button.Outline
    onClicked: drawer.open()

    Drawer {
        id: drawer
        side: "bottom"
        modal: false
        title: qsTr("Non-modal drawer")
        description: qsTr("The page behind stays interactive while this drawer is open.")

        footer: Button {
            text: qsTr("Close")
            variant: Button.Outline
            onClicked: drawer.close()
        }
    }
}
