import QtQuick
import Shadcn

// Scrollable Content —— 内容超高时用 ScrollView 滚动,header 保持可见(对标 dialog-scrollable-content)。
// 关键:给 ScrollView 一个固定 implicitHeight 作为最大高度,内容 Column 超出即滚动;
// Dialog 依此高度定尺,header/footer 在滚动区之外。
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
            implicitHeight: 300          // max-h,超出滚动
            clip: true
            contentWidth: availableWidth // 只纵向滚动
            rightPadding: Theme.space3   // 给滚动条留位

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
