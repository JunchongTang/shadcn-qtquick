import QtQuick
import QtQuick.Layouts
import Shadcn

Button {
    text: qsTr("Open Popover")
    variant: Button.Outline
    onClicked: pop.open()

    Popover {
        id: pop
        align: Popover.Align.Start

        // header:gap-1
        ColumnLayout {
            width: pop.availableWidth
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
    }
}
