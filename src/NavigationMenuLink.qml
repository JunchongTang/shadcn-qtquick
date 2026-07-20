import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn NavigationMenuLink(base-mira)—— 下拉面板内的单条链接(也可独立使用)。
// = <NavigationMenuLink class="flex items-center gap-1.5 rounded-md p-2 text-xs/relaxed
//   hover:bg-muted data-[active=true]:bg-muted/50">。
//
// 三种形态自适应:纯标题 / 标题 + 图标(size-4) / 标题 + 描述(muted,line-clamp-2)。
// 点击发出 triggered();在面板内点击后由 NavigationMenuContent 关闭菜单。
Item {
    id: link

    property string text: ""          // 标题
    property string description: ""   // 次要描述(muted 双行)
    property string iconName: ""      // 前置 Lucide 图标
    property bool active: false       // data-[active=true]

    signal triggered()

    Layout.fillWidth: true
    implicitWidth: 180
    implicitHeight: col.implicitHeight + Theme.space2 * 2   // p-2

    readonly property bool _hovered: hover.hovered

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusMd   // in-content:rounded-md
        color: {
            if (link.active)
                return link._hovered ? Theme.muted : Theme.alpha(Theme.muted, 0.5)
            return link._hovered ? Theme.muted : "transparent"
        }
    }

    ColumnLayout {
        id: col
        x: Theme.space2
        y: Theme.space2
        width: parent.width - Theme.space2 * 2
        spacing: link.description !== "" ? Theme.space1 : 0

        // 标题行(图标 + 文本)
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.space1_5   // gap-1.5

            LucideIcon {
                visible: link.iconName !== ""
                name: link.iconName
                size: 16              // size-4
                color: Theme.foreground
                Layout.preferredWidth: visible ? 16 : 0
                Layout.preferredHeight: 16
            }
            Text {
                Layout.fillWidth: true
                text: link.text
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                font.weight: Font.Medium   // leading-none font-medium
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
        }

        // 描述(可选,双行截断)
        Text {
            visible: link.description !== ""
            Layout.fillWidth: true
            text: link.description
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            lineHeight: Theme.lineRelaxed
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
            maximumLineCount: 2        // line-clamp-2
            elide: Text.ElideRight
        }
    }

    HoverHandler { id: hover }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: link.triggered()
    }
}
