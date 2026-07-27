import QtQuick
import QtQuick.Layouts
import Shadcn

Button {
    id: trigger
    text: qsTr("Open popover")
    variant: Button.Outline
    onClicked: pop.open()

    Popover {
        id: pop
        width: 320                       // w-80

        ColumnLayout {
            width: pop.availableWidth
            spacing: 16                  // gap-4

            // Title + description (space-y-2)
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
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

            // Field list (grid gap-2)
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Repeater {
                    model: [
                        { label: qsTr("Width"), value: "100%" },
                        { label: qsTr("Max. width"), value: "300px" },
                        { label: qsTr("Height"), value: "25px" },
                        { label: qsTr("Max. height"), value: "none" }
                    ]
                    delegate: RowLayout {
                        required property var modelData
                        Layout.fillWidth: true
                        spacing: 16
                        Label {
                            text: modelData.label
                            Layout.preferredWidth: 96
                        }
                        Input {
                            Layout.fillWidth: true
                            text: modelData.value
                        }
                    }
                }
            }
        }
    }
}
