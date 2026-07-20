import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Slider(base-mira)—— 单值滑块。
// track:bg-muted、rounded-md、h-1(水平)/ w-1(垂直);range:bg-primary;
// thumb:size-3(12px)、rounded-md、border-ring、bg-white,hover/focus/active 显示 ring-2 ring/30。
// 基类别名导入(as C)以便文件名 Slider 不与基类自引用冲突。
C.Slider {
    id: control

    from: 0
    to: 100
    stepSize: 1

    // 注:C.Slider 自带只读 FINAL 属性 horizontal(= orientation===Qt.Horizontal),直接用 control.horizontal。

    implicitWidth: horizontal ? 200 : 12
    implicitHeight: horizontal ? 12 : 160   // 垂直默认 min-h-40 = 160
    padding: 0
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // 键盘可 Tab 聚焦;方向键调整由 Slider 基类处理
    live: true
    // data-disabled:opacity-50
    opacity: enabled ? 1.0 : 0.5

    // ==== 轨道(bg-muted)+ 指示条(bg-primary)====
    background: Rectangle {
        id: track
        x: control.leftPadding + (control.horizontal ? 0 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : 0)
        implicitWidth: control.horizontal ? 200 : 4
        implicitHeight: control.horizontal ? 4 : 160
        width: control.horizontal ? control.availableWidth : 4    // h-1 / w-1
        height: control.horizontal ? 4 : control.availableHeight
        radius: Theme.radiusMd
        color: Theme.muted
        clip: true                                               // overflow-hidden

        Rectangle {
            radius: Theme.radiusMd
            color: Theme.primary
            // 水平:自左向右;垂直:自底向上(value 越大越靠上)。
            width: control.horizontal ? control.position * track.width : track.width
            height: control.horizontal ? track.height : control.position * track.height
            y: control.horizontal ? 0 : track.height - height
        }
    }

    // ==== 滑块(rounded-md 白底 + ring 描边 + 焦点环)====
    handle: Rectangle {
        id: thumb
        x: control.leftPadding + (control.horizontal
            ? control.visualPosition * (control.availableWidth - width)
            : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal
            ? (control.availableHeight - height) / 2
            : control.visualPosition * (control.availableHeight - height))
        implicitWidth: 12                                        // size-3
        implicitHeight: 12
        radius: Theme.radiusMd
        color: "#ffffff"                                         // bg-white(明暗一致)
        border.width: 1
        border.color: Theme.ring                                 // border-ring

        // hover:ring-2 / focus-visible:ring-2 / active:ring-2(ring/30)
        FocusRing {
            active: control.hovered || control.visualFocus || control.pressed
            targetRadius: thumb.radius
        }
    }
}
