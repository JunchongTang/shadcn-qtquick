import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn Alert(base-mira) —— rounded-lg border + px-2 py-1.5,前置图标 + 标题 + 描述,
// 可选右侧 action 槽;颜色可覆盖(用于自定义配色示例)。
Rectangle {
    id: control

    enum Variant { Default, Destructive }
    property int variant: Alert.Default
    property string title: ""
    property string description: ""
    property string iconName: ""

    // 颜色令牌(默认按变体;可整体覆盖做自定义配色)。
    property color surface: Theme.card
    property color stroke: Theme.border
    property color titleColor: variant === Alert.Destructive ? Theme.destructive : Theme.cardForeground
    property color descColor: variant === Alert.Destructive
                              ? Theme.alpha(Theme.destructive, 0.9) : Theme.mutedForeground

    default property alias action: actionSlot.data

    implicitWidth: 400
    implicitHeight: row.implicitHeight + Theme.space1_5 * 2
    radius: Theme.radiusLg
    color: surface
    border.width: 1
    border.color: stroke

    RowLayout {
        id: row
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: Theme.space2
        anchors.rightMargin: Theme.space2
        anchors.topMargin: Theme.space1_5
        spacing: Theme.space1_5

        LucideIcon {
            visible: control.iconName !== ""
            name: control.iconName
            size: 14
            color: control.titleColor
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 2
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Text {
                visible: control.title !== ""
                text: control.title
                color: control.titleColor
                font.pixelSize: Theme.textXs
                font.weight: Font.Medium
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
            Text {
                visible: control.description !== ""
                Layout.fillWidth: true
                text: control.description
                color: control.descColor
                font.pixelSize: Theme.textXs
                lineHeight: Theme.lineRelaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
            }
        }

        // 右侧 action 槽(如按钮),顶部对齐。
        Item {
            id: actionSlot
            visible: children.length > 0
            Layout.alignment: Qt.AlignTop
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }
}
