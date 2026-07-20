import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Input —— 含焦点外圈(focus ring),对标前端 focus-visible:border-ring + ring-[3px]。
C.TextField {
    id: control

    property bool invalid: false    // aria-invalid → 破坏色描边 + 环
    // 在 ButtonGroup 中的相邻位置(由 ButtonGroup 自动设置)—— 拉直相邻内侧圆角。
    property int groupPosition: Button.GroupNone
    property bool groupVertical: false

    implicitHeight: 28              // h-7
    leftPadding: Theme.space2       // px-2
    rightPadding: Theme.space2
    topPadding: 0
    bottomPadding: 0
    font.pixelSize: Theme.textXs
    color: Theme.foreground
    placeholderTextColor: Theme.mutedForeground
    selectionColor: Theme.alpha(Theme.primary, 0.35)
    selectedTextColor: Theme.foreground
    verticalAlignment: TextInput.AlignVCenter

    // 分组内聚焦时抬到最上层(对标 focus-visible:z-10),让 ring 色边框盖住与相邻按钮
    // 重合(spacing:-1)的那条共享边 —— 否则右边框会被后绘制的邻居边框遮住,颜色不同步。
    z: activeFocus ? 10 : 0

    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        // 分组时拉直相邻内侧角(逐角推导,机制同 Button)。
        readonly property bool _n: control.groupPosition === Button.GroupNone
        readonly property bool _f: control.groupPosition === Button.GroupFirst
        readonly property bool _l: control.groupPosition === Button.GroupLast
        readonly property bool _v: control.groupVertical
        topLeftRadius:     (_n || _f) ? radius : 0
        bottomRightRadius: (_n || _l) ? radius : 0
        topRightRadius:    (_n || (!_v && _l) || (_v && _f)) ? radius : 0
        bottomLeftRadius:  (_n || (!_v && _f) || (_v && _l)) ? radius : 0
        color: Theme.alpha(Theme.input, 0.2)      // bg-input/20 微填充
        border.width: 1
        border.color: control.invalid ? Theme.destructive
                     : control.activeFocus ? Theme.ring : Theme.border
        Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid 破坏色环
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: bg.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.destructive, 0.2)
            visible: control.invalid
            z: -1
        }

        // 焦点环随背景逐角圆角(分组拉直的一侧同为直角)。
        FocusRing {
            active: control.activeFocus
            targetRadius: bg.radius
            targetTopLeft: bg.topLeftRadius
            targetTopRight: bg.topRightRadius
            targetBottomLeft: bg.bottomLeftRadius
            targetBottomRight: bg.bottomRightRadius
        }
    }
}
