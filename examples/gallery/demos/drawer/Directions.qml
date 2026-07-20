import QtQuick
import QtQuick.Layouts
import Shadcn

// Direction variants: one trigger per edge (top / right / bottom / left), each
// opening a Drawer that slides in from that side.
Flow {
    id: root
    spacing: Theme.space2

    Repeater {
        model: [
            { label: "Top",    side: "top" },
            { label: "Right",  side: "right" },
            { label: "Bottom", side: "bottom" },
            { label: "Left",   side: "left" }
        ]
        delegate: Button {
            required property var modelData
            text: modelData.label
            variant: Button.Outline
            onClicked: {
                d.side = modelData.side
                d.open()
            }
        }
    }

    Drawer {
        id: d
        title: qsTr("Direction")
        description: qsTr("This drawer slides in from the \"" + d.side + "\" edge.")

        footer: Button {
            text: qsTr("Done")
            onClicked: d.close()
        }
    }
}
