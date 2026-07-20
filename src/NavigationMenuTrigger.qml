import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn NavigationMenuTrigger(base-mira)—— 导航项的可点击触发头。
// = <NavigationMenuTrigger class="rounded-lg px-2.5 py-1.5 text-xs/relaxed font-medium
//   hover:bg-muted data-popup-open:bg-muted/50 data-popup-open:hover:bg-muted">
//   {children} <ChevronDownIcon class="ml-1 size-3 group-data-open:rotate-180" />。
//
// 由 NavigationMenuItem 内部实例化;也可单独作为「触发头样式」的链接使用。
// entered/exited/clicked 上抛给宿主 Item 做 hover 开合协调。
Item {
    id: trigger

    property string text: ""
    property bool showChevron: true   // 纯链接项传 false 隐藏 chevron
    property bool open: false         // 面板是否展开(chevron 旋转 + 底色)

    signal entered()
    signal exited()
    signal clicked()

    readonly property real _hpad: Theme.space2_5   // px-2.5
    readonly property real _vpad: Theme.space1_5   // py-1.5

    implicitWidth: row.implicitWidth + _hpad * 2
    implicitHeight: row.implicitHeight + _vpad * 2

    // data-popup-open:bg-muted/50 · (open|hover):bg-muted
    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusLg
        color: {
            if (trigger.open)
                return hover.hovered ? Theme.muted : Theme.alpha(Theme.muted, 0.5)
            return hover.hovered ? Theme.muted : Theme.alpha(Theme.muted, 0)
        }
        Behavior on color { ColorAnimation { duration: Theme.durBase } }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: Theme.space1   // ml-1

        Text {
            text: trigger.text
            color: Theme.foreground
            font.pixelSize: Theme.textXs
            font.weight: Font.Medium
            verticalAlignment: Text.AlignVCenter
        }
        LucideIcon {
            visible: trigger.showChevron
            name: "chevron-down"
            size: 12                      // size-3
            color: Theme.foreground
            Layout.preferredWidth: visible ? 12 : 0
            // group-data-open:rotate-180,transition duration-300
            rotation: trigger.open ? 180 : 0
            Behavior on rotation { NumberAnimation { duration: 300 } }
        }
    }

    HoverHandler { id: hover }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: trigger.entered()
        onExited: trigger.exited()
        onClicked: trigger.clicked()
    }
}
