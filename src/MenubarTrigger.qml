import QtQuick
import QtQuick.Controls.Basic as C

// shadcn MenubarTrigger(base-mira)—— 顶部菜单栏里的单个触发按钮(File/Edit/…)。
// CSS: hover:bg-muted aria-expanded:bg-muted rounded-[calc(radius-md-2px)]
//      px-2 py-[0.85] text-xs/relaxed font-medium。
// 唯一命名,避免与基类 MenuBarItem 等冲突。
C.AbstractButton {
    id: control

    property bool open: false        // 对应 aria-expanded(所属菜单展开)

    // hover 或 open 时高亮(bg-muted;本主题 muted==accent)。
    readonly property bool _active: control.hovered || control.open

    leftPadding: Theme.space2        // px-2
    rightPadding: Theme.space2
    topPadding: Theme.space1         // ≈ py-[0.85](3.4px 取 4)
    bottomPadding: Theme.space1
    font.pixelSize: Theme.textXs     // text-xs
    font.weight: Font.Medium         // font-medium
    hoverEnabled: true

    implicitWidth: label.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.round(Theme.textXs * Theme.lineRelaxed) + topPadding + bottomPadding

    contentItem: Text {
        id: label
        text: control.text
        font: control.font
        color: Theme.foreground
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: Theme.radiusSm       // calc(radius-md - 2px) = 8-2 = 6
        color: control._active ? Theme.muted : Theme.alpha(Theme.muted, 0)
        Behavior on color { ColorAnimation { duration: Theme.durFast } }
    }
}
