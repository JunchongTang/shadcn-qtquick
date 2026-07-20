import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn AccordionItem(base-mira) —— trigger(p-2 text-xs + 右侧 chevron 旋转)+ 可折叠内容。
// 展开时 data-open:bg-muted/50;非末项底部 1px 分隔线。默认可独立开合(type=multiple)。
Item {
    id: item

    property string title: ""
    property bool expanded: false
    property bool last: false
    default property alias content: body.data

    width: parent ? parent.width : 400
    implicitHeight: header.height + contentClip.height + (item.last ? 0 : 1)

    Column {
        width: parent.width

        // ---- 触发器 ----
        Rectangle {
            id: header
            width: parent.width
            height: 34
            opacity: item.enabled ? 1.0 : 0.5
            color: item.expanded ? Theme.alpha(Theme.muted, 0.5) : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.space2
                anchors.rightMargin: Theme.space2
                spacing: Theme.space2

                Text {
                    Layout.fillWidth: true
                    text: item.title
                    color: Theme.foreground
                    font.pixelSize: Theme.textXs
                    font.weight: Font.Medium
                    font.underline: hover.hovered
                    verticalAlignment: Text.AlignVCenter
                }
                LucideIcon {
                    name: "chevron-down"
                    size: 16
                    color: Theme.mutedForeground
                    rotation: item.expanded ? 180 : 0
                    Behavior on rotation { NumberAnimation { duration: Theme.durFast } }
                }
            }

            HoverHandler { id: hover }
            TapHandler { onTapped: item.expanded = !item.expanded }
        }

        // ---- 可折叠内容 ----
        Item {
            id: contentClip
            width: parent.width
            height: item.expanded ? body.implicitHeight + Theme.space2 + Theme.space4 : 0
            clip: true
            Behavior on height { NumberAnimation { duration: Theme.durBase; easing.type: Easing.OutCubic } }

            ColumnLayout {
                id: body
                x: Theme.space2                       // px-2
                y: 0
                width: parent.width - Theme.space2 * 2
                spacing: Theme.space2
            }
        }
    }

    // 非末项底部分隔线(not-last:border-b)
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        visible: !item.last
        color: Theme.border
    }
}
