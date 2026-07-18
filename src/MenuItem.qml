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

    readonly property bool _active: control.highlighted || control.hovered
    readonly property color _fg: _active ? Theme.accentForeground : Theme.popoverForeground

    contentItem: RowLayout {
        spacing: control.spacing
        LucideIcon {
            visible: control.iconName !== ""
            name: control.iconName
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
    }

    background: Rectangle {
        radius: Theme.radiusMd       // rounded-md
        color: control._active ? Theme.accent : "transparent"  // focus:bg-accent
        Behavior on color { ColorAnimation { duration: Theme.durFast } }
    }
}
