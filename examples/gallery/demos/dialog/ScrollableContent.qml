import QtQuick
import Shadcn

// Scrollable Content -- when content overflows, scroll it with a ScrollView while the header stays visible (matches dialog-scrollable-content).
// Key: give the ScrollView a fixed implicitHeight as its max height; the content Column scrolls once it overflows;
// the Dialog sizes to this height, and header/footer stay outside the scroll area.
Button {
    text: qsTr("Scrollable Content")
    variant: Button.Outline
    onClicked: dialog.open()

    Dialog {
        id: dialog
        title: qsTr("Scrollable Content")
        description: qsTr("This is a dialog with scrollable content.")

        ScrollView {
            id: scroll
            width: dialog.availableWidth
            implicitHeight: 300          // max-h, scroll on overflow
            clip: true
            contentWidth: availableWidth // vertical scrolling only
            rightPadding: Theme.space3   // leave room for the scrollbar

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
    }
}
