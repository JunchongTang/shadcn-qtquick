import QtQuick
import QtQuick.Layouts
import Shadcn

// Bubble with Popover: the failed bubble's reaction row holds an info button that expands full error details on click.
// Mirrors official bubble-popover.
ColumnLayout {
    width: 360
    spacing: 16

    Bubble {
        align: Bubble.End
        BubbleContent { text: qsTr("Run the build script.") }
    }

    Bubble {
        variant: Bubble.Destructive
        BubbleContent { text: qsTr("Failed to run the command.") }
        BubbleReactions {
            padded: false
            Button {
                id: infoBtn
                variant: Button.Ghost
                size: Button.IconXs
                iconName: "info"
                onClicked: errPop.open()

                Popover {
                    id: errPop
                    width: 288
                    align: Popover.Align.End

                    ColumnLayout {
                        width: errPop.availableWidth
                        spacing: 6
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Command failed with exit code 1")
                            color: Theme.foreground
                            font.pixelSize: Theme.textSm
                            font.weight: Font.Medium
                            wrapMode: Text.Wrap
                        }
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("ENOENT: no such file or directory, open pnpm-lock.yaml")
                            color: Theme.mutedForeground
                            font.pixelSize: Theme.textSm
                            wrapMode: Text.Wrap
                        }
                    }
                }
            }
        }
    }
}
