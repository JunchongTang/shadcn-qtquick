import QtQuick
import QtQuick.Layouts

// shadcn CardHeader —— 标题区,gap-1(4px) 垂直堆叠 CardTitle / CardDescription。
// 水平内边距由 Card 的统一 margin 提供,此处只管内部堆叠。
ColumnLayout {
    Layout.fillWidth: true
    spacing: Theme.space1
}
