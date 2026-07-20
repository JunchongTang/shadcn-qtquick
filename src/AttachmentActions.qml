import QtQuick
import QtQuick.Layouts

// shadcn AttachmentActions —— 附件操作位(移除/重试/复制…)。对标 .cn-attachment-actions:
// shrink-0、items-center、z-20(始终位于 AttachmentTrigger 覆盖层之上,保持独立可点)。
// 水平朝向:随内容拉伸挤到右侧,按钮相邻;垂直朝向:由父绝对定位到右上、gap-1。
RowLayout {
    id: actions

    readonly property string attachSlot: "attachment-actions"
    // 由父 Attachment 注入朝向(垂直 → gap-1)。
    property int hostOrientation: Attachment.Horizontal

    z: 20
    spacing: hostOrientation === Attachment.Vertical ? Theme.space1 : 0
}
