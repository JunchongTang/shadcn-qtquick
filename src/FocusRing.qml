import QtQuick

// shadcn 焦点环 —— base-mira 的 focus-visible:ring-2 ring-ring/30。
// 用法:置于目标背景 Rectangle 内,填满并向外扩 ringWidth,由 active 控制显隐。
// targetRadius 传目标背景的 radius,本环圆角随之加大以保持等距。
// 对标 CSS 的 ring(无 offset):环紧贴元素外边缘,向外 2px。
Rectangle {
    id: root

    property bool active: false
    property real targetRadius: Theme.radiusMd
    // 可选:逐角目标半径(分组拉直时用)。-1 表示沿用 targetRadius。
    // 传目标背景对应角的半径即可,本环会自动 +ringWidth 保持等距(目标角为 0 时环角也为 0=直角)。
    property real targetTopLeft: -1
    property real targetTopRight: -1
    property real targetBottomLeft: -1
    property real targetBottomRight: -1
    function _ringR(corner) {
        var t = (corner < 0) ? targetRadius : corner
        return t <= 0 ? 0 : t + Theme.ringWidth
    }

    anchors.fill: parent
    anchors.margins: -Theme.ringWidth
    radius: targetRadius + Theme.ringWidth
    topLeftRadius: _ringR(targetTopLeft)
    topRightRadius: _ringR(targetTopRight)
    bottomLeftRadius: _ringR(targetBottomLeft)
    bottomRightRadius: _ringR(targetBottomRight)
    color: "transparent"
    border.width: Theme.ringWidth
    border.color: Theme.alpha(Theme.ring, Theme.ringOpacity)
    visible: active
    z: -1
}
