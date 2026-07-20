import QtQuick
import QtQuick.Layouts

// shadcn AttachmentName(= 官方 AttachmentTitle)—— 附件名。text-xs / font-medium / truncate。
// uploading / processing 时标题微光(shimmer)。此处用不透明度呼吸近似官方的渐变扫光。
Text {
    id: name

    readonly property string attachSlot: "attachment-name"
    property int hostState: Attachment.Done

    readonly property bool _shimmer: hostState === Attachment.Uploading
                                   || hostState === Attachment.Processing

    color: Theme.foreground
    font.pixelSize: Theme.textXs
    font.weight: Font.Medium
    elide: Text.ElideRight            // truncate 单行
    Layout.fillWidth: true

    // 微光近似(shimmer):进行中时标题做轻微透明度呼吸。
    SequentialAnimation {
        id: shimmerAnim
        running: name._shimmer && name.visible
        loops: Animation.Infinite
        NumberAnimation { target: name; property: "opacity"; from: 1.0; to: 0.5; duration: 700; easing.type: Easing.InOutSine }
        NumberAnimation { target: name; property: "opacity"; from: 0.5; to: 1.0; duration: 700; easing.type: Easing.InOutSine }
    }
    onHostStateChanged: if (!_shimmer) opacity = 1.0
}
