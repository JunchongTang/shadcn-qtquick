import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import LucideIcons

// shadcn Sonner —— 单条 toast 的视觉(base-mira)。
// 对标 registry/bases/base/ui/sonner.tsx 的 --normal-* 变量 + .cn-toast { rounded-md }:
//   bg popover · text popover-foreground · rounded-md · 浮层描边(ring-1 ring-foreground/10)+ shadow-md。
// 与 popover/dialog/menu 同属浮层家族,故用 Theme.overlayRing + Theme.shadow*(mira 统一浮层立体感)。
// 类型图标沿用 sonner 的 icons 映射(circle-check/info/triangle-alert/octagon-x/loader-circle),
// base-mira 未启用 richColors,图标随文本色(popover-foreground),不额外着色。
Rectangle {
    id: control

    enum Type { Default, Success, Info, Warning, Error, Loading }

    property int type: Toast.Default
    property string title: ""
    property string description: ""
    property string actionText: ""      // 非空则显示右侧动作按钮

    signal actionTriggered()

    // 类型 → Lucide 图标名(Default 无图标)。
    readonly property string _iconName: {
        switch (type) {
        case Toast.Success: return "circle-check"
        case Toast.Info: return "info"
        case Toast.Warning: return "triangle-alert"
        case Toast.Error: return "octagon-x"
        case Toast.Loading: return "loader-circle"
        default: return ""
        }
    }
    readonly property bool _hasIcon: _iconName !== ""

    // sonner 默认宽度 356;固定宽度,内容按需换行。
    implicitWidth: 356
    implicitHeight: Math.max(row.implicitHeight + Theme.space4 * 2, 44)
    radius: Theme.radiusMd                // .cn-toast: rounded-md
    color: Theme.popover                  // --normal-bg: var(--popover)
    border.width: Theme.overlayRingWidth  // ring-1 ring-foreground/10
    border.color: Theme.overlayRing

    // shadow-md(mira 浮层统一)。
    layer.enabled: true
    layer.effect: MultiEffect {
        autoPaddingEnabled: true
        shadowEnabled: true
        shadowColor: Theme.shadowColor
        shadowBlur: Theme.shadowBlur
        shadowVerticalOffset: Theme.shadowOffset
    }

    RowLayout {
        id: row
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Theme.space4   // p-4
        anchors.rightMargin: Theme.space4
        spacing: Theme.space3              // gap-3(图标与文本)

        LucideIcon {
            visible: control._hasIcon
            name: control._iconName
            size: 16                       // size-4
            color: Theme.popoverForeground
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 1
            // loading 图标旋转。
            RotationAnimation on rotation {
                running: control.type === Toast.Loading && control._hasIcon
                from: 0; to: 360
                duration: 900
                loops: Animation.Infinite
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space1          // gap-1(标题/描述)
            Text {
                visible: control.title !== ""
                Layout.fillWidth: true
                text: control.title
                color: Theme.popoverForeground
                font.pixelSize: Theme.textSm
                font.weight: Font.Medium
                wrapMode: Text.Wrap
            }
            Text {
                visible: control.description !== ""
                Layout.fillWidth: true
                text: control.description
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                lineHeight: Theme.lineRelaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
            }
        }

        // 右侧动作按钮(sonner action)。
        Button {
            visible: control.actionText !== ""
            text: control.actionText
            size: Button.Xs
            Layout.alignment: Qt.AlignVCenter
            onClicked: control.actionTriggered()
        }
    }
}
