import QtQuick
import QtQuick.Controls.Basic as C
import LucideIcons

// shadcn AttachmentAction —— 附件内的图标操作按钮。对标官方 Button size=icon-xs、variant=ghost。
// 20×20、rounded-sm、悬停 bg-muted;svg 14。label 供无障碍(aria-label 语义)。
C.Button {
    id: control

    property string iconName: ""
    property string label: ""          // 无障碍标签(对标 aria-label)

    readonly property string attachSlot: "attachment-action"

    implicitWidth: 20                  // icon-xs
    implicitHeight: 20
    padding: 0
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5

    contentItem: Item {
        LucideIcon {
            anchors.centerIn: parent
            name: control.iconName
            size: 14
            color: control.hovered ? Theme.foreground : Theme.mutedForeground
        }
    }

    background: Rectangle {
        radius: Theme.radiusSm
        color: control.hovered ? Theme.muted : Theme.alpha(Theme.muted, 0)
        Behavior on color { ColorAnimation { duration: Theme.durFast } }

        // 1px 焦点环(ring-1 ring-ring/30)。
        Rectangle {
            anchors.fill: parent
            anchors.margins: -1
            radius: parent.radius + 1
            color: "transparent"
            border.width: 1
            border.color: Theme.alpha(Theme.ring, Theme.ringOpacity)
            visible: control.activeFocus
        }
    }
}
