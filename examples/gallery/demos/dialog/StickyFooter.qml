import QtQuick
import QtQuick.Layouts
import Shadcn

// Sticky Footer —— 长内容在 ScrollView 里滚动,footer 用 footer 槽固定底部(对标 dialog-sticky-footer)。
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
            implicitHeight: 300          // max-h,超出滚动
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

        // footer 固定在滚动区之外
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
