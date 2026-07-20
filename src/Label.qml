import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Label —— 表单标签。
// 文件名 Label 与基类 QtQuick.Controls.Basic.Label 同名,必须别名导入(as C),
// 根对象用 C.Label,避免类型自引用循环。
C.Label {
    id: control

    color: Theme.foreground
    font.pixelSize: Theme.textXs        // text-xs/relaxed
    font.weight: Font.Medium
    // 禁用时变暗(对标 group-data-[disabled]:opacity-50)。
    opacity: enabled ? 1.0 : 0.5
    verticalAlignment: Text.AlignVCenter
}
