import QtQuick
import Shadcn

// Submenu: a nested Menu hosts secondary actions (sub-trigger auto-adds a right-side chevron).
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

        MenuItem { text: qsTr("Copy"); shortcut: "⌘C" }
        MenuItem { text: qsTr("Cut"); shortcut: "⌘X" }

        Menu {
            title: qsTr("More Tools")
            MenuItem { text: qsTr("Save Page...") }
            MenuItem { text: qsTr("Create Shortcut...") }
            MenuItem { text: qsTr("Name Window...") }
            MenuSeparator {}
            MenuItem { text: qsTr("Developer Tools") }
            MenuSeparator {}
            MenuItem { text: qsTr("Delete"); destructive: true }
        }
    }
}
