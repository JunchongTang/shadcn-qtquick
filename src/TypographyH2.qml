import QtQuick

// shadcn Typography h2 —— text-3xl(30) font-semibold tracking-tight border-b pb-2。
// tracking-tight -0.025em → -0.75px @30。line-height 2.25rem(36) → 1.2。
// pb-2 = 8px 底部内边距,其下 1px border-b。整体块级,边框横贯整宽。
Item {
    id: root
    property alias text: label.text

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight + 8 + 1   // pb-2 + border

    Text {
        id: label
        width: root.width
        color: Theme.foreground
        font.family: Theme.fontHeading
        font.pixelSize: 30
        font.weight: Font.DemiBold
        font.letterSpacing: -0.75
        lineHeight: 1.2
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
        textFormat: Text.PlainText
    }
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Theme.border
    }
}
