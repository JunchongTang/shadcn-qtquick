import QtQuick
import QtQuick.Layouts
import Shadcn

// Sticky Footer -- long content scrolls inside a ScrollView, while the footer is pinned to the bottom via the footer slot (matches dialog-sticky-footer).
Button {
    text: qsTr("Sticky Footer")
    variant: Button.Outline
    onClicked: dialog.open()

    Dialog {
        id: dialog
        title: qsTr("Sticky Footer")
        description: qsTr("This dialog has a sticky footer that stays visible while the content scrolls.")

        ScrollView {
            id: scroll
            width: dialog.availableWidth
            implicitHeight: 300          // max-h, scroll on overflow
            clip: true
            contentWidth: availableWidth
            rightPadding: Theme.space3

            Column {
                width: scroll.availableWidth
                spacing: Theme.space4
                Repeater {
                    model: 8
                    delegate: Text {
                        width: parent.width
                        text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
                        color: Theme.foreground
                        font.pixelSize: Theme.textSm
                        wrapMode: Text.Wrap
                        lineHeight: 1.5
                        lineHeightMode: Text.ProportionalHeight
                    }
                }
            }
        }

        // footer pinned outside the scroll area
        footerContent: RowLayout {
            Item { Layout.fillWidth: true }
            Button {
                text: qsTr("Close")
                variant: Button.Outline
                onClicked: dialog.close()
            }
        }
    }
}
