import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import LucideIcons

// shadcn DropdownMenuCheckboxItem(base-mira)——
// 勾选态以「右侧 CheckIcon」呈现(item-indicator: absolute right-2;item 用 pr-8 pl-2 留位)。
C.MenuItem {
    id: control

    property string iconName: ""     // 可选左侧图标(如 checkboxes-icons 示例)

    checkable: true
    implicitHeight: 28               // min-h-7
    leftPadding: Theme.space2        // pl-2
    rightPadding: Theme.space8       // pr-8 (32)
    topPadding: Theme.space1_5       // py-1.5
    bottomPadding: Theme.space1_5
    spacing: Theme.space2            // gap-2
    font.pixelSize: Theme.textXs
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5
    arrow: null

    // 显式按内容算宽(含右侧勾选 gutter=rightPadding),使 Menu 按最宽项自增、文本不省略。
    implicitWidth: leftPadding + rightPadding
                   + (iconName !== "" ? 14 + spacing : 0)
                   + Math.ceil(_labelMetrics.advanceWidth) + 1
    TextMetrics { id: _labelMetrics; font: control.font; text: control.text }

    readonly property bool _active: control.highlighted || control.hovered
    readonly property color _fg: control._active ? Theme.accentForeground : Theme.popoverForeground

    // 右侧勾选指示(cn-dropdown-menu-item-indicator: absolute right-2)
    indicator: LucideIcon {
        x: control.width - width - Theme.space2
        y: (control.height - height) / 2
        name: "check"
        size: 14                     // svg size-3.5
        color: control._fg
        visible: control.checked
    }

    contentItem: RowLayout {
        spacing: control.spacing
        LucideIcon {
            visible: control.iconName !== ""
            name: control.iconName
            size: 14
            color: control._fg
            Layout.preferredWidth: visible ? 14 : 0
            Layout.preferredHeight: 14
        }
        Text {
            text: control.text
            font: control.font
            color: control._fg
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            Layout.fillWidth: true
        }
    }

    background: Rectangle {
        radius: Theme.radiusMd       // rounded-md
        color: control._active ? Theme.accent : "transparent"  // focus:bg-accent
    }
}
