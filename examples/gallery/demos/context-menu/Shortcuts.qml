import QtQuick
import Shadcn

// Shortcut hints: right-aligned muted text (cn-context-menu-shortcut).
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

        MenuItem { text: qsTr("Back"); shortcut: "⌘[" }
        MenuItem { text: qsTr("Forward"); enabled: false; shortcut: "⌘]" }
        MenuItem { text: qsTr("Reload"); shortcut: "⌘R" }
        MenuSeparator {}
        MenuItem { text: qsTr("Save"); shortcut: "⌘S" }
        MenuItem { text: qsTr("Save As..."); shortcut: "⇧⌘S" }
    }
}
