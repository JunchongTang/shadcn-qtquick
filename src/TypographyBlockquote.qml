import QtQuick

// shadcn Typography blockquote —— border-l-2 pl-6 italic。
// 左侧 2px 边框 + 24px 左内边距 + 斜体正文(16px foreground)。
Item {
    id: root
    property alias text: quote.text

    implicitWidth: quote.implicitWidth + 24
    implicitHeight: quote.implicitHeight

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 2
        color: Theme.border
    }
    Text {
        id: quote
        anchors.left: parent.left
        anchors.leftMargin: 24        // pl-6
        anchors.right: parent.right
        color: Theme.foreground
        font.family: Theme.fontSans
        font.pixelSize: Theme.textBase
        font.italic: true
        lineHeight: 1.6
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
        textFormat: Text.PlainText
    }
}
