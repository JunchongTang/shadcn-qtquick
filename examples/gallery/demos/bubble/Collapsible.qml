import QtQuick
import QtQuick.Layouts
import Shadcn

// Show More / 折叠:长内容用预览 + "Show more/less" 切换。对标官方 bubble-collapsible。
ColumnLayout {
    id: root
    width: 360
    spacing: 32

    readonly property string fullText:
        "The accessibility review found two focus states that were visually too subtle in dark mode.\n\n"
      + "I checked the dialog, menu, and drawer paths because each one renders focusable controls inside a layered surface.\n\n"
      + "The dialog and drawer are fine. The menu needs the hover and focus tokens split so keyboard focus stays visible when the pointer is not involved.\n\n"
      + "I also recommend keeping the change in the style file instead of the primitive so the other themes can choose their own focus treatment later."
    readonly property int previewLength: 180
    readonly property bool isLong: fullText.length > previewLength
    property bool open: false

    Bubble {
        variant: Bubble.Muted
        BubbleContent { text: "How can I help you today?" }
    }

    Bubble {
        variant: Bubble.Muted
        align: Bubble.End
        BubbleContent {
            id: bc
            ColumnLayout {
                Layout.maximumWidth: bc._innerMaxW
                spacing: Theme.space1
                Text {
                    Layout.fillWidth: true
                    text: (root.open || !root.isLong)
                          ? root.fullText
                          : root.fullText.substring(0, root.previewLength) + "..."
                    color: Theme.foreground
                    font.pixelSize: Theme.textXs
                    lineHeight: Theme.lineRelaxed
                    lineHeightMode: Text.ProportionalHeight
                    wrapMode: Text.Wrap
                }
                Button {
                    visible: root.isLong
                    variant: Button.Link
                    size: Button.Xs
                    text: root.open ? "Show less" : "Show more"
                    trailingIconName: root.open ? "chevron-up" : "chevron-down"
                    onClicked: root.open = !root.open
                }
            }
        }
    }
}
