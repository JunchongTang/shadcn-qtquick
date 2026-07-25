import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 24                          // gap-6

    Button {
        text: qsTr("Start")
        variant: Button.Outline
        size: Button.Sm
        onClicked: startPop.open()
        Popover {
            id: startPop
            width: 160                   // w-40
            align: Popover.Align.Start
            Text {
                width: startPop.availableWidth
                text: qsTr("Aligned to start")
                color: Theme.popoverForeground
                font.pixelSize: Theme.textXs
                wrapMode: Text.Wrap
            }
        }
    }

    Button {
        text: qsTr("Center")
        variant: Button.Outline
        size: Button.Sm
        onClicked: centerPop.open()
        Popover {
            id: centerPop
            width: 160
            align: Popover.Align.Center
            Text {
                width: centerPop.availableWidth
                text: qsTr("Aligned to center")
                color: Theme.popoverForeground
                font.pixelSize: Theme.textXs
                wrapMode: Text.Wrap
            }
        }
    }

    Button {
        text: qsTr("End")
        variant: Button.Outline
        size: Button.Sm
        onClicked: endPop.open()
        Popover {
            id: endPop
            width: 160
            align: Popover.Align.End
            Text {
                width: endPop.availableWidth
                text: qsTr("Aligned to end")
                color: Theme.popoverForeground
                font.pixelSize: Theme.textXs
                wrapMode: Text.Wrap
            }
        }
    }
}
