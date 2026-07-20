import QtQuick

// shadcn Accordion(base-mira) —— overflow-hidden rounded-md border 容器,内含 AccordionItem。
Item {
    id: control
    property bool bordered: true       // 卡片内嵌时可关闭外框
    default property alias content: col.data

    implicitWidth: 400
    implicitHeight: col.implicitHeight

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusMd
        color: "transparent"
        border.width: control.bordered ? 1 : 0
        border.color: Theme.border
    }

    Column {
        id: col
        width: parent.width
    }
}
