import QtQuick
import Shadcn

Rectangle {
    color: Theme.background
    implicitWidth: 440
    implicitHeight: 320

    Item {
        id: area
        x: 24
        y: 24
        width: 392
        height: 180

        Canvas {
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
        }
        Text {
            anchors.centerIn: parent
            text: "Right click here"
            color: Theme.foreground
            font.pixelSize: Theme.textSm
        }

        ContextMenu {
            id: ctx
            target: area
            MenuItem { text: "Back" }
            MenuItem { text: "Forward"; enabled: false }
            MenuItem { text: "Reload" }
        }
    }

    Component.onCompleted: ctx.popup(120, 70)
}
