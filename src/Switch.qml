import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Switch(base-mira) —— 胶囊轨道 + 圆形滑块。checked→primary,unchecked→input。
C.Switch {
    id: control

    enum Size { Default, Sm }
    property int size: Switch.Default
    property bool invalid: false        // aria-invalid → 破坏色描边 + 环

    readonly property real _w: size === Switch.Sm ? 24 : 28
    readonly property real _h: size === Switch.Sm ? 14 : 17     // h-[16.6px]≈17
    readonly property real _thumb: size === Switch.Sm ? 12 : 14 // size-3.5 / size-3

    implicitWidth: _w
    implicitHeight: _h
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // 键盘可 Tab 聚焦(Space/Enter 切换由 AbstractButton 自带)
    opacity: enabled ? 1.0 : 0.5

    indicator: Rectangle {
        id: track
        implicitWidth: control._w
        implicitHeight: control._h
        radius: height / 2
        color: control.checked ? Theme.primary : Theme.input
        border.width: control.invalid ? 1 : 0
        border.color: Theme.destructive
        Behavior on color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid 破坏色环
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: track.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.destructive, 0.2)
            visible: control.invalid
            z: -1
        }

        Rectangle {
            id: thumb
            width: control._thumb
            height: control._thumb
            radius: height / 2
            y: (parent.height - height) / 2
            x: control.checked ? parent.width - width - 1.5 : 1.5
            color: Theme.background
            Behavior on x { NumberAnimation { duration: Theme.durFast; easing.type: Easing.OutCubic } }
        }

        FocusRing { active: control.visualFocus; targetRadius: track.radius }
    }
}
