import QtQuick
import QtQuick.Layouts

// shadcn FieldSeparator —— FieldGroup 内的分节分隔(relative h-5 -my-2)。
// 一条居中横线;若给了 text,则在中间盖一枚背景色文字片(bg-background px-2 muted text-xs)。
Item {
    id: sep

    property string text: ""

    Layout.fillWidth: true
    implicitHeight: 20              // h-5
    Layout.topMargin: -Theme.space2   // -my-2
    Layout.bottomMargin: -Theme.space2

    // 贯穿横线(top-1/2)。
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 1
        color: Theme.border
    }

    // 居中文字片:用背景色遮住线,营造“文字断线”的效果。
    Rectangle {
        anchors.centerIn: parent
        visible: sep.text !== ""
        width: chip.implicitWidth + Theme.space2 * 2   // px-2
        height: parent.height
        color: Theme.background

        Text {
            id: chip
            anchors.centerIn: parent
            text: sep.text
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
    }
}
