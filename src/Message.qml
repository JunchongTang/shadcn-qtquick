import QtQuick
import QtQuick.Layouts

// shadcn Message(base-mira)—— 会话中的一行消息:头像 + 内容气泡 + 头/脚 + hover 操作。
// 布局:一行(RowLayout),align=End 时整行翻转(flex-row-reverse),头像贴右、内容靠右。
// 自包含:内容气泡由 MessageContent 绘制,不依赖 Bubble。
//
// 组合(与官方一致):
//   Message { align }
//   ├── MessageAvatar { source; fallback }        // 可选;空槽为对齐间隔件
//   └── MessageContent { header; text; variant; footer; <IconButton…操作> }
//
// 子件通过父链自动继承本行的 align(用户只需在 Message 上设置一次)。
//
// 未实现(基础版诚实跳过):MessageGroup 精细堆叠(可用 ColumnLayout+紧间距近似,见 demos/message/Group)、
// 有 footer 时头像的 -translate-y-8 上移对齐、富文本/markdown、流式打字(仅提供 typing 点动画视觉)。
RowLayout {
    id: root

    enum Align { Start, End }
    property int align: Message.Start

    // 供子件(MessageContent/…)父链识别本行并读取 align。
    readonly property bool isMessageRow: true

    Layout.fillWidth: true
    spacing: Theme.space1_5             // gap-1.5
    layoutDirection: align === Message.End ? Qt.RightToLeft : Qt.LeftToRight
}
