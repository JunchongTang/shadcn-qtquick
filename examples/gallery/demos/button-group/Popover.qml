import QtQuick
import QtQuick.Layouts
import Shadcn

// Official button-group-popover: main action button + chevron trigger, opens rich Popover content.
ButtonGroup {
    Button { variant: Button.Outline; iconName: "bot"; text: qsTr("Copilot") }
    Button {
        id: chevron
        variant: Button.Outline
        size: Button.Icon
        iconName: "chevron-down"
        onClicked: pop.open()

        Popover {
            id: pop
            align: Popover.Align.End
            width: 288

            ColumnLayout {
                width: pop.availableWidth
                spacing: Theme.space2

                Text {
                    text: qsTr("Start a new task with Copilot")
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm
                    font.weight: Font.Medium
                }
                Text {
                    Layout.fillWidth: true
                    text: qsTr("Describe your task in natural language.")
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textXs
                    wrapMode: Text.Wrap
                }
                Textarea {
                    Layout.fillWidth: true
                    placeholderText: qsTr("I need to...")
                }
                Text {
                    Layout.fillWidth: true
                    text: qsTr("Copilot will open a pull request for review.")
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textXs
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}
