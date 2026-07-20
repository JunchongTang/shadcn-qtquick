import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import LucideIcons

// shadcn DropdownMenuItem。文件名 MenuItem 与基类 MenuItem 同名 → 别名导入(as C)。
// text 继承自 AbstractButton,直接使用,不重复声明(避免遮蔽)。
C.MenuItem {
    id: control

    property string shortcut: ""     // 右侧快捷键提示(text-muted)
    property string iconName: ""     // 左侧 Lucide 图标(AbstractButton.icon 为 FINAL,故用 iconName)
    property bool destructive: false // data-[variant=destructive]:text-destructive + focus bg-destructive/10

    implicitHeight: 28               // min-h-7
    leftPadding: Theme.space2        // px-2
    rightPadding: Theme.space2
    topPadding: 0
    bottomPadding: 0
    spacing: Theme.space2            // gap-2
    font.pixelSize: Theme.textXs
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5     // data-disabled:opacity-50
    indicator: null
    arrow: null

    // 显式按内容算宽:RowLayout + fillWidth Text 的隐式宽算不准,会让 Menu 卡在 min-w 而省略文本。
    // 据此 C.Menu 能按最宽项自增,文本完整显示。
    implicitWidth: leftPadding + rightPadding
                   + (_iconName !== "" ? 14 + spacing : 0)
                   + Math.ceil(_labelMetrics.advanceWidth) + 1
                   + (shortcut !== "" ? spacing + Math.ceil(_shortcutMetrics.advanceWidth) : 0)
                   + (subMenu !== null ? spacing + 14 : 0)
    TextMetrics { id: _labelMetrics; font: control.font; text: control.text }
    TextMetrics { id: _shortcutMetrics; font.pixelSize: 10; font.letterSpacing: 1; text: control.shortcut }

    readonly property bool _active: control.highlighted || control.hovered
    // 子菜单触发项由 Menu 的 delegate 自动创建(subMenu 非空);图标取自子菜单的 icon.name。
    readonly property string _iconName: control.subMenu ? control.subMenu.icon.name : control.iconName
    readonly property color _fg: control.destructive
        ? Theme.destructive
        : (control._active ? Theme.accentForeground : Theme.popoverForeground)

    contentItem: RowLayout {
        spacing: control.spacing
        LucideIcon {
            visible: control._iconName !== ""
            name: control._iconName
            size: 14                 // svg size-3.5
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
        Text {
            visible: control.shortcut !== ""
            text: control.shortcut
            font.pixelSize: 10       // text-[0.625rem]
            font.letterSpacing: 1    // tracking-widest
            color: control._active ? Theme.accentForeground : Theme.mutedForeground
            verticalAlignment: Text.AlignVCenter
        }
        // 子菜单触发项右侧 chevron(sub-trigger: ChevronRightIcon ml-auto)
        LucideIcon {
            visible: control.subMenu !== null
            name: "chevron-right"
            size: 14
            color: control._fg
            Layout.preferredWidth: visible ? 14 : 0
            Layout.preferredHeight: 14
        }
    }

    background: Rectangle {
        radius: Theme.radiusMd       // rounded-md
        // focus:bg-accent / destructive focus:bg-destructive/10 (dark:/20)
        color: control.destructive
            ? (control._active ? Theme.alpha(Theme.destructive, Theme.dark ? 0.2 : 0.1) : "transparent")
            : (control._active ? Theme.accent : "transparent")
    }
}
