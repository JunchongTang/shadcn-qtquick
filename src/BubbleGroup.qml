import QtQuick
import QtQuick.Layouts

// shadcn BubbleGroup(base-mira)—— 归组连续同源气泡。对标 .cn-bubble-group:
//   flex flex-col · gap-2(相对独立气泡间的大间距,把同源连发收得更紧凑)。
// 注意:mira 不对组内气泡做圆角合并——每条仍是 rounded-lg,分组仅收紧竖向间距。
//   align 请设在各 Bubble 自身上(组不代持)。
//
// 用法:
//   BubbleGroup {
//       Bubble { align: Bubble.End; BubbleContent { text: "A" } }
//       Bubble { align: Bubble.End; BubbleContent { text: "B" } }
//   }
ColumnLayout {
    id: group
    spacing: Theme.space2   // gap-2
    // 标记:供 BubbleContent 识别"我被套在组里",从而把 max-width 基准上溯到真正的会话列
    // (组自身是 fillWidth 布局,宽度由子项反推,直接读会与子项隐式宽形成绑定环)。
    readonly property bool isBubbleGroup: true
    // 组本身在外层会话列里默认占满宽度,组内各 Bubble 按各自 align 自对齐。
    Layout.fillWidth: true
}
