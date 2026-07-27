import QtQuick
import Shadcn

// Combined example: groups + shortcuts + submenu + checkboxes + radio (mirrors context-menu-demo).
// Trigger area is a dashed-border square; right-click opens the menu at the cursor.
Item {
    id: area
    implicitWidth: 320               // max-w-xs
    implicitHeight: 180              // aspect-video

    // Dashed border hint (border-dashed rounded-xl)
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
        implicitWidth: 192           // w-48

        MenuItem { text: qsTr("Back"); shortcut: "⌘[" }
        MenuItem { text: qsTr("Forward"); enabled: false; shortcut: "⌘]" }
        MenuItem { text: qsTr("Reload"); shortcut: "⌘R" }

        Menu {
            title: qsTr("More Tools")
            implicitWidth: 176       // w-44

            MenuItem { text: qsTr("Save Page...") }
            MenuItem { text: qsTr("Create Shortcut...") }
            MenuItem { text: qsTr("Name Window...") }
            MenuSeparator {}
            MenuItem { text: qsTr("Developer Tools") }
            MenuSeparator {}
            MenuItem { text: qsTr("Delete"); destructive: true }
        }

        MenuSeparator {}
        MenuCheckboxItem { text: qsTr("Show Bookmarks"); checked: true }
        MenuCheckboxItem { text: qsTr("Show Full URLs") }

        MenuSeparator {}
        MenuLabel { text: qsTr("People") }
        MenuRadioItem { text: qsTr("Pedro Duarte"); checked: true }
        MenuRadioItem { text: qsTr("Colm Tuite") }
    }
}
