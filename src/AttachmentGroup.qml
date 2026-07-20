import QtQuick

// shadcn AttachmentGroup —— 把多个 Attachment 横向排布为可滚动的一行。对标 .cn-attachment-group:
// gap-3(12)、py-1(4)、横向溢出滚动。默认子项进入内部 Row。
// 近似说明:官方还有 snap 对齐与两侧渐隐(scroll-fade-x / snap-mandatory);这里实现功能性
// 横向滚动与间距,snap 与边缘渐隐从简省略(纯视觉修饰,不影响可用性)。
Flickable {
    id: group

    default property alias content: row.data

    readonly property string attachSlot: "attachment-group"

    contentWidth: row.width
    contentHeight: row.height
    flickableDirection: Flickable.HorizontalFlick
    boundsBehavior: Flickable.StopAtBounds
    clip: true

    implicitWidth: row.implicitWidth + 8
    implicitHeight: row.implicitHeight + 8    // py-1 上下各 4

    Row {
        id: row
        x: 4                                  // scroll-px-1 近似
        y: 4                                  // py-1
        spacing: 12                           // gap-3
    }
}
