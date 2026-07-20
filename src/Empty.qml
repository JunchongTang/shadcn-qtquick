import QtQuick
import QtQuick.Layouts

// shadcn Empty(base-mira) —— 居中空状态容器。
// 对齐 .cn-empty:flex-col items-center justify-center text-center;gap-4 rounded-xl border-dashed p-6。
// 默认无边框(border 宽度为 0),outline 时显示虚线边框;surface 可加背景色(对应 bg-* 工具类)。
// 组合:Empty { EmptyHeader { EmptyMedia; EmptyTitle; EmptyDescription } EmptyContent { ... } }
Rectangle {
    id: control

    // 虚线边框(对应 web 的 `border border-dashed`)。
    property bool outline: false
    // 背景色(对应 bg-*,默认透明)。
    property color surface: "transparent"

    // 子件进入居中的内部 ColumnLayout(header / content / 额外动作)。
    default property alias content: inner.data

    color: surface
    radius: Theme.radiusXl                                   // rounded-xl = 14
    implicitWidth: inner.implicitWidth + Theme.space6 * 2    // p-6 左右
    implicitHeight: inner.implicitHeight + Theme.space6 * 2  // p-6 上下

    // Rectangle 不支持虚线描边,用 Canvas 画圆角虚线框(outline 时)。
    Canvas {
        id: dashed
        anchors.fill: parent
        visible: control.outline
        property color strokeColor: Theme.border
        onStrokeColorChanged: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onVisibleChanged: requestPaint()
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            if (!control.outline)
                return
            ctx.strokeStyle = strokeColor
            ctx.lineWidth = 1
            ctx.setLineDash([4, 4])
            var r = control.radius
            var x = 0.5, y = 0.5
            var w = width - 1, h = height - 1
            ctx.beginPath()
            ctx.moveTo(x + r, y)
            ctx.arcTo(x + w, y, x + w, y + h, r)
            ctx.arcTo(x + w, y + h, x, y + h, r)
            ctx.arcTo(x, y + h, x, y, r)
            ctx.arcTo(x, y, x + w, y, r)
            ctx.closePath()
            ctx.stroke()
        }
    }

    ColumnLayout {
        id: inner
        anchors.centerIn: parent
        spacing: Theme.space4    // gap-4 = 16
    }
}
