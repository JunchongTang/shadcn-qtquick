import QtQuick
import QtQuick.Layouts

// shadcn AttachmentContent —— 承载 AttachmentName + AttachmentSize 的纵向内容列(flex-1)。
// 对标 .cn-attachment-content:leading-tight;垂直朝向额外 px-1。
// 把宿主 state 转发给子件(名称微光、大小 error 变色)。
ColumnLayout {
    id: content

    readonly property string attachSlot: "attachment-content"

    property int hostSize: Attachment.Default
    property int hostState: Attachment.Done
    property bool contentFill: true

    Layout.alignment: Qt.AlignVCenter
    // 垂直朝向内容左右各 px-1(4);由父路由时无法预知朝向,这里用小边距近似,水平朝向亦无碍。
    spacing: 0

    onHostStateChanged: _forward()
    Component.onCompleted: _forward()

    function _forward() {
        for (var i = 0; i < children.length; i++) {
            var c = children[i]
            if (c && c.hostState !== undefined)
                c.hostState = content.hostState
        }
    }
}
