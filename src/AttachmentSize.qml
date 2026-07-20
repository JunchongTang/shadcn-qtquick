import QtQuick
import QtQuick.Layouts

// shadcn AttachmentSize(= 官方 AttachmentDescription)—— 次要元信息:文件类型/大小/上传状态。
// 对标 .cn-attachment-description:mt-0.5、text-xs、text-muted-foreground、truncate。
// error 态:destructive/80(把失败原因写在这里,不靠颜色单独表意)。
Text {
    id: meta

    readonly property string attachSlot: "attachment-size"
    property int hostState: Attachment.Done

    readonly property bool _error: hostState === Attachment.Error

    color: _error ? Theme.alpha(Theme.destructive, 0.80) : Theme.mutedForeground
    font.pixelSize: Theme.textXs
    elide: Text.ElideRight
    Layout.fillWidth: true
    Layout.topMargin: 2          // mt-0.5
}
