import QtQuick
import Shadcn

// 图标 + 标签:MenuItem.iconName 取 Lucide 图标名(左侧 size-3.5)。
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
        text: qsTr("Right click here")
        color: Theme.foreground
        font.pixelSize: Theme.textSm
    }

    ContextMenu {
        target: area

        MenuItem { text: qsTr("Copy"); iconName: "copy" }
        MenuItem { text: qsTr("Cut"); iconName: "scissors" }
        MenuItem { text: qsTr("Paste"); iconName: "clipboard-paste" }
        MenuSeparator {}
        MenuItem { text: qsTr("Delete"); iconName: "trash-2"; destructive: true }
    }
}
