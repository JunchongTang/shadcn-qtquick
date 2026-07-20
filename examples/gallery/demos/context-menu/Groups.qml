import QtQuick
import Shadcn

// 分组:用 MenuLabel 作分组小标题、MenuSeparator 作分隔线。
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

        MenuLabel { text: "File" }
        MenuItem { text: "New File"; shortcut: "⌘N" }
        MenuItem { text: "Open File"; shortcut: "⌘O" }
        MenuItem { text: "Save"; shortcut: "⌘S" }
        MenuSeparator {}
        MenuLabel { text: "Edit" }
        MenuItem { text: "Undo"; shortcut: "⌘Z" }
        MenuItem { text: "Redo"; shortcut: "⇧⌘Z" }
        MenuSeparator {}
        MenuItem { text: "Cut"; shortcut: "⌘X" }
        MenuItem { text: "Copy"; shortcut: "⌘C" }
        MenuItem { text: "Paste"; shortcut: "⌘V" }
        MenuSeparator {}
        MenuItem { text: "Delete"; destructive: true; shortcut: "⌫" }
    }
}
