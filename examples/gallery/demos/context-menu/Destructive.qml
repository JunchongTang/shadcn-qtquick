import QtQuick
import Shadcn

// 破坏性项:destructive 使文本/图标转为 destructive 色,focus 背景转 destructive/10。
Item {
    id: area
    implicitWidth: 320
    implicitHeight: 180

    Canvas {
        id: dashed
        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()
            ctx.strokeStyle = Theme.border
            ctx.lineWidth = 1
            ctx.setLineDash([4, 4])
            ctx.beginPath()
            ctx.roundedRect(0.5, 0.5, width - 1, height - 1, 12, 12)
            ctx.stroke()
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Connections { target: Theme; function onDarkChanged() { dashed.requestPaint() } }
    }

    Text {
        anchors.centerIn: parent
        text: "Right click here"
        color: Theme.foreground
        font.pixelSize: Theme.textSm
    }

    ContextMenu {
        target: area

        MenuItem { text: "Edit"; iconName: "pencil" }
        MenuItem { text: "Share"; iconName: "share" }
        MenuSeparator {}
        MenuItem { text: "Delete"; iconName: "trash-2"; destructive: true }
    }
}
