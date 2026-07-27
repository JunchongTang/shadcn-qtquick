import QtQuick
import QtQuick.Layouts
import Shadcn

Button {
    text: qsTr("Open Popover")
    variant: Button.Outline
    onClicked: pop.open()

    Popover {
        id: pop
        width: 256                       // w-64
        align: Popover.Align.Start

        ColumnLayout {
            width: pop.availableWidth
            spacing: 16                  // gap-4

            // header: gap-1
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                Text {
                    text: qsTr("Dimensions")
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm
                    font.weight: Font.Medium
                }
                Text {
                    Layout.fillWidth: true
                    text: qsTr("Set the dimensions for the layer.")
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textXs
                    wrapMode: Text.Wrap
                }
            }

            // FieldGroup: gap-4, label takes half the width
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Label { text: qsTr("Width"); Layout.preferredWidth: pop.availableWidth / 2 }
                    Input { Layout.fillWidth: true; text: "100%" }
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Label { text: qsTr("Height"); Layout.preferredWidth: pop.availableWidth / 2 }
                    Input { Layout.fillWidth: true; text: qsTr("25px") }
                }
            }
        }
    }
}
