import QtQuick
import QtQuick.Layouts
import Shadcn

// Official collapsible-settings —— "Radius" settings card: two pinned inputs + a trigger
// button on the right (toggles maximize/minimize icon); expanding reveals two more inputs
// below.
Card {
    id: root
    width: 320
    size: Card.Small

    CardHeader {
        CardTitle { text: qsTr("Radius") }
        CardDescription { text: qsTr("Set the corner radius of the element.") }
    }

    CardContent {
        Collapsible {
            id: c
            Layout.fillWidth: true
            gap: 8

            // ---- Pinned: first row of two inputs + trigger button ----
            trigger: RowLayout {
                width: parent.width
                spacing: 8
                Input { Layout.fillWidth: true; placeholderText: "0"; text: "0" }
                Input { Layout.fillWidth: true; placeholderText: "0"; text: "0" }
                Button {
                    variant: Button.Outline
                    size: Button.Icon
                    iconName: c.expanded ? qsTr("minimize") : qsTr("maximize")
                    onClicked: c.toggle()
                }
            }

            // ---- Collapsible: second row of two inputs (reserves a button column on the right for alignment) ----
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Input { Layout.fillWidth: true; placeholderText: "0"; text: "0" }
                Input { Layout.fillWidth: true; placeholderText: "0"; text: "0" }
                Item { Layout.preferredWidth: 28 }
            }
        }
    }
}
