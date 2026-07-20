import QtQuick
import QtQuick.Layouts
import Shadcn

Button {
    id: trigger
    text: "Open popover"
    variant: Button.Outline
    onClicked: pop.open()

    Popover {
        id: pop
        width: 320                       // w-80

        ColumnLayout {
            width: pop.availableWidth
            spacing: 16                  // gap-4

            // 标题 + 描述(space-y-2)
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Text {
                    text: "Dimensions"
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm
                    font.weight: Font.Medium
                }
                Text {
                    Layout.fillWidth: true
                    text: "Set the dimensions for the layer."
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textXs
                    wrapMode: Text.Wrap
                }
            }

            // 字段列表(grid gap-2)
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Repeater {
                    model: [
                        { label: "Width", value: "100%" },
                        { label: "Max. width", value: "300px" },
                        { label: "Height", value: "25px" },
                        { label: "Max. height", value: "none" }
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
