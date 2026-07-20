import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Slider(base-mira)—— 区间/双滑块。视觉与 Slider.qml 完全一致:
// track:bg-muted、rounded-md、h-1(水平)/ w-1(垂直);中段 range:bg-primary(位于两个 thumb 之间);
// thumb:size-3(12px)、rounded-md、border-ring、bg-white,hover/focus/active 显示 ring-2 ring/30。
// 基于 C.RangeSlider(first/second 两个滑块节点);API 沿用 from/to/stepSize/orientation,
// 区间值经 first.value / second.value 读写(defaultValue={[a,b]})。
C.RangeSlider {
    id: control

    from: 0
    to: 100
    stepSize: 1

    // 注:C.RangeSlider 同样自带只读 FINAL 属性 horizontal(= orientation===Qt.Horizontal)。
    implicitWidth: horizontal ? 200 : 12
    implicitHeight: horizontal ? 12 : 160   // 垂直默认 min-h-40 = 160
    padding: 0
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // 键盘可 Tab 聚焦;方向键调整由 RangeSlider 基类处理
    live: true
    // data-disabled:opacity-50
    opacity: enabled ? 1.0 : 0.5

    // ==== 轨道(bg-muted)+ 中段指示条(bg-primary,两 thumb 之间)====
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
            // 水平:自 first 到 second;垂直:自底向上,同样取两节点之间。
            x: control.horizontal ? control.first.position * track.width : 0
            width: control.horizontal
                ? (control.second.position - control.first.position) * track.width
                : track.width
            height: control.horizontal
                ? track.height
                : (control.second.position - control.first.position) * track.height
            y: control.horizontal ? 0 : track.height - control.second.position * track.height
        }
    }

    // ==== 滑块一(rounded-md 白底 + ring 描边 + 焦点环)====
    first.handle: Rectangle {
        id: firstThumb
        x: control.leftPadding + (control.horizontal
            ? control.first.visualPosition * (control.availableWidth - width)
            : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal
            ? (control.availableHeight - height) / 2
            : control.first.visualPosition * (control.availableHeight - height))
        implicitWidth: 12                                        // size-3
        implicitHeight: 12
        radius: Theme.radiusMd
        color: "#ffffff"                                         // bg-white(明暗一致)
        border.width: 1
        border.color: Theme.ring                                 // border-ring

        // hover:ring-2 / focus-visible:ring-2 / active:ring-2(ring/30)
        FocusRing {
            active: control.first.hovered || control.first.pressed || control.visualFocus
            targetRadius: firstThumb.radius
        }
    }

    // ==== 滑块二 ====
    second.handle: Rectangle {
        id: secondThumb
        x: control.leftPadding + (control.horizontal
            ? control.second.visualPosition * (control.availableWidth - width)
            : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal
            ? (control.availableHeight - height) / 2
            : control.second.visualPosition * (control.availableHeight - height))
        implicitWidth: 12
        implicitHeight: 12
        radius: Theme.radiusMd
        color: "#ffffff"
        border.width: 1
        border.color: Theme.ring

        FocusRing {
            active: control.second.hovered || control.second.pressed || control.visualFocus
            targetRadius: secondThumb.radius
        }
    }
}
