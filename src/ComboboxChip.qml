import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn Combobox chip —— 多选模式触发器内的一枚"已选项"标签(小圆角块 + × 移除)。
// 对齐 .cn-combobox-chip:bg-muted-foreground/10、text-foreground、h-[4.75]=19、gap-1、
//   px-1.5、rounded-[calc(--radius-sm - 2px)]、text-xs、font-medium、whitespace-nowrap;
//   有移除键时右内边距归零(has-data-[slot=combobox-chip-remove]:pr-0)。
// 移除键(.cn-combobox-chip-remove):-ml-1、opacity-50 → hover 时 opacity-100。
Item {
    id: chip

    property string text: ""
    property bool removable: true
    signal removed()

    readonly property real _padLeft: Theme.space1_5                          // px-1.5
    readonly property real _padRight: removable ? 0 : Theme.space1_5         // has-remove:pr-0

    implicitHeight: 19                                                       // h-[calc(--spacing(4.75))]
    implicitWidth: _padLeft + row.implicitWidth + _padRight

    Rectangle {
        anchors.fill: parent
        radius: Math.max(0, Theme.radiusSm - 2)                             // rounded-[calc(radius-sm - 2px)]
        color: Theme.alpha(Theme.mutedForeground, 0.1)                      // bg-muted-foreground/10
    }

    RowLayout {
        id: row
        anchors.left: parent.left
        anchors.leftMargin: chip._padLeft
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.space1                                               // gap-1

        Text {
            text: chip.text
            color: Theme.foreground
            font.pixelSize: Theme.textXs
            font.weight: Font.Medium
        }

        // 移除键(× ):-ml-1 抵消 gap-1,使其贴近标签;opacity 50 → hover 100。
        Item {
            visible: chip.removable
            Layout.preferredWidth: 14
            Layout.preferredHeight: 14
            Layout.leftMargin: -Theme.space1                                // -ml-1
            LucideIcon {
                anchors.centerIn: parent
                name: "x"
                size: 12
                color: Theme.foreground
                opacity: rm.hovered ? 1.0 : 0.5
            }
            HoverHandler { id: rm; cursorShape: Qt.PointingHandCursor }
            TapHandler { onTapped: chip.removed() }
        }
    }
}
