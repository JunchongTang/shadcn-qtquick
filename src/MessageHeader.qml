import QtQuick
import QtQuick.Layouts

// shadcn MessageHeader(base-mira)—— 气泡上方的发送者名/元信息。
// text-[0.625rem](10px)font-medium text-muted-foreground、px-2.5;
// 官方规定 header 始终左对齐(不随 align 翻转),故固定 AlignLeft。
Text {
    id: root

    text: ""
    visible: text !== ""
    color: Theme.mutedForeground
    font.pixelSize: 10                 // text-[0.625rem]
    font.weight: Font.Medium
    leftPadding: Theme.space2_5        // px-2.5
    rightPadding: Theme.space2_5
    elide: Text.ElideRight
    Layout.alignment: Qt.AlignLeft
    Layout.maximumWidth: parent ? parent.width : implicitWidth
}
