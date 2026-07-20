import QtQuick
import Shadcn

// 复选项:MenuCheckboxItem 切换态以右侧勾选呈现。
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

        MenuCheckboxItem { text: "Show Bookmarks Bar"; checked: true }
        MenuCheckboxItem { text: "Show Full URLs" }
        MenuCheckboxItem { text: "Show Developer Tools"; checked: true }
    }
}
