import QtQuick

// shadcn AttachmentTrigger —— 使整张附件卡可激活(打开链接/对话框)。对标 .cn-attachment-trigger:
// absolute inset-0 z-10,覆盖全卡但位于 actions 之下,故操作按钮仍独立可点。
//
// 实现:本身是一个「标记」子项(无渲染)。父 Attachment 检测到它后,会在卡片内容之下铺设
// 一个可聚焦按钮覆盖层,点击/回车时回调本组件的 clicked() 并触发 Attachment.triggered()。
// label 提供无障碍语义(对标 aria-label)。真实拖放/文件选择逻辑用静态近似,由消费方连接 clicked。
Item {
    id: trigger

    readonly property string attachSlot: "attachment-trigger"
    property string label: ""

    signal clicked()

    visible: false
    width: 0
    height: 0
}
