import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8

    // 用 Link 变体把 Badge 当链接展示,后置 arrow-up-right 图标。
    Badge {
        variant: Badge.Link
        text: qsTr("Open Link")
        trailingIconName: "arrow-up-right"
    }
}
