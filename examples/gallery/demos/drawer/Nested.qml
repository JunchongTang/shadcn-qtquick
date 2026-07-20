import QtQuick
import QtQuick.Layouts
import Shadcn

// Nested: a drawer opened from within another drawer; the parent stays mounted
// behind the child.
Button {
    text: qsTr("Open Drawer")
    variant: Button.Outline
    onClicked: outer.open()

    Drawer {
        id: outer
        side: "bottom"
        title: qsTr("Drawer")
        description: qsTr("This drawer can open another drawer on top of it.")

        Button {
            Layout.fillWidth: true
            text: qsTr("Open nested drawer")
            variant: Button.Outline
            onClicked: inner.open()
        }

        footer: Button {
            text: qsTr("Close")
            variant: Button.Outline
            onClicked: outer.close()
        }

        Drawer {
            id: inner
            side: "bottom"
            title: qsTr("Nested drawer")
            description: qsTr("Opened from within the parent drawer.")

            footer: Button {
                text: qsTr("Close")
                variant: Button.Outline
                onClicked: inner.close()
            }
        }
    }
}
