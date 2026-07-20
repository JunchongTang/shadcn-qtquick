import QtQuick
import QtQuick.Layouts

// shadcn ItemSeparator —— ItemGroup 中两个 Item 之间的横向分隔线,上下留白 my-2(各 8px)。
Item {
    readonly property string itemSlot: "item-separator"

    Layout.fillWidth: true
    implicitHeight: 1 + Theme.space2 * 2   // 1px 线 + my-2

    Separator {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        orientation: Separator.Horizontal
    }
}
