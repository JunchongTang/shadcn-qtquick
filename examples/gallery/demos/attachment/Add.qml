import QtQuick
import QtQuick.Layouts
import Shadcn

// 附加节(非官方独立小节,覆盖题述「添加附件按钮/拖放区近似」):
// 用 idle 虚线态 + 全卡 Trigger 近似一个「点击添加/拖放上传」入口。
// 说明:真实文件选择与拖放逻辑此处不实现,仅静态近似交互外观(点击弹出提示计数)。
ColumnLayout {
    id: root
    width: 360
    spacing: 10

    property int _added: 0

    Attachment {
        Layout.fillWidth: true
        uploadState: Attachment.Idle          // 虚线描边 → 拖放区外观

        AttachmentMedia { iconName: "upload" }
        AttachmentContent {
            AttachmentName { text: qsTr("Add attachment") }
            AttachmentSize { text: qsTr("Drag and drop or click to browse") }
        }
        AttachmentTrigger { label: qsTr("Add attachment") }
        onTriggered: root._added++
    }

    Text {
        visible: root._added > 0
        text: root._added + " file(s) added (demo)"
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
    }
}
