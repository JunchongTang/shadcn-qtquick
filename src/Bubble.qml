import QtQuick
import QtQuick.Layouts

// shadcn Bubble(base-mira)—— 会话气泡容器。对标 .cn-bubble:
//   flex flex-col gap-1 · w-fit · max-w-[80%](ghost 变体解除上限为 100%)· data-[align=end]:self-end。
//
// 组成(对齐 registry 的 Bubble / BubbleContent / BubbleReactions / BubbleGroup):
//   Bubble
//   ├── BubbleContent     气泡内容面(承载底色/圆角/内边距,即视觉主体)
//   └── BubbleReactions   叠在气泡边缘的表情/操作小胶囊(绝对定位,可选)
//
// 用法:
//   ColumnLayout {                        // 会话列(需有确定宽度,80% 上限据此计算)
//       width: 360
//       Bubble {
//           variant: Bubble.Muted
//           align: Bubble.Start
//           BubbleContent { text: "Hey!" }
//           BubbleReactions { Text { text: "👍" } }
//       }
//   }
//
// 说明:
//   · variant/align 定义在本类型上,由子件 BubbleContent/BubbleReactions 读取。
//   · Bubble 自身尺寸绑定到内容面(_contentRef,由 BubbleContent 完成时注册),
//     表情行溢出气泡边缘但不计入尺寸——故会话列需用较大 spacing 预留竖向空间。
//   · 连续同源气泡请置于 BubbleGroup 内(仅将间距收紧为 gap-2;mira 不做圆角合并)。
Item {
    id: root

    enum Variant { Default, Secondary, Muted, Tinted, Outline, Ghost, Destructive }
    enum Align { Start, End }

    property int variant: Bubble.Default
    property int align: Bubble.Start
    // 内容面相对会话列宽度的上限比例(对标 max-w-[80%];ghost 变体内部解除为 100%)。
    property real maxWidthRatio: 0.8

    // 由 BubbleContent 在完成时注册,驱动本容器尺寸(表情行不参与)。
    property Item _contentRef: null

    implicitWidth: _contentRef ? _contentRef.implicitWidth : 0
    implicitHeight: _contentRef ? _contentRef.implicitHeight : 0

    // 会话列内的行内对齐(self-start / self-end)。非 Layout 场景下自动忽略。
    Layout.alignment: (align === Bubble.End ? Qt.AlignRight : Qt.AlignLeft) | Qt.AlignVCenter
}
