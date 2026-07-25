import QtQuick
import QtQuick.Layouts
import Shadcn

Rectangle {
    color: Theme.background
    implicitWidth: 420
    implicitHeight: 180

    Button {
        id: trigger
        x: 24
        y: 24
        text: "Open Popover"
        variant: Button.Outline

        Popover {
            id: pop
            align: Popover.Align.Start

            ColumnLayout {
                width: pop.availableWidth
                spacing: 4
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
        }
    }

    Component.onCompleted: pop.open()
}
