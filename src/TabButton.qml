import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Effects

// shadcn Tabs 触发器 —— 文件名与基类同名(TabButton),必须别名导入并以 C.TabButton 为根,
// 释放 TabButton 供枚举访问、规避继承环。
// 选中(checked/current)→ background 底 + foreground 字 + radiusSm + 轻投影;
// 未选中 → mutedForeground 字 + 透明底,hover 转 foreground。
C.TabButton {
    id: control

    implicitHeight: 24
    leftPadding: Theme.space2
    rightPadding: Theme.space2
    topPadding: 0
    bottomPadding: 0
    font.pixelSize: Theme.textXs
    font.weight: Font.Medium
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5   // disabled

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.checked || control.hovered || control.down
               ? Theme.foreground : Theme.mutedForeground
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        Behavior on color { ColorAnimation { duration: Theme.durFast } }
    }

    background: Item {
        // 激活胶囊:选中时显 background 底 + 轻投影(shadow-sm);暗色下加 input 描边。
        Rectangle {
            id: pill
            anchors.fill: parent
            radius: Theme.radiusSm
            color: control.checked ? Theme.background : "transparent"
            border.width: control.checked && Theme.dark ? 1 : 0
            border.color: Theme.input
            layer.enabled: control.checked
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Theme.alpha(Theme.foreground, 0.12)
                shadowVerticalOffset: 1
                shadowBlur: 0.35
            }
            Behavior on color { ColorAnimation { duration: Theme.durFast } }
        }

        // 焦点外圈(focus-visible ring),对标前端 focus-visible:ring-[3px]。
        Rectangle {
            anchors.fill: pill
            anchors.margins: -Theme.ringWidth
            radius: pill.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.ring, Theme.ringOpacity)
            visible: control.visualFocus
        }
    }
}
