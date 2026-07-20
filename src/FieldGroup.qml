import QtQuick
import QtQuick.Layouts

// shadcn FieldGroup —— 堆叠一组 Field 的容器(flex flex-col gap-4)。
// 需要分隔时在其间放 FieldSeparator。
ColumnLayout {
    Layout.fillWidth: true
    spacing: Theme.space4        // gap-4
}
