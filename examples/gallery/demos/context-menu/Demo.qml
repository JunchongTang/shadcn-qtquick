import QtQuick
import Shadcn

// 组合示例:分组 + 快捷键 + 子菜单 + 复选 + 单选(对标 context-menu-demo)。
// 触发区域为虚线边框方块,右键即在光标处弹出。
Item {
    id: area
    implicitWidth: 320               // max-w-xs
    implicitHeight: 180              // aspect-video

    // 虚线边框提示(border-dashed rounded-xl)
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
        implicitWidth: 192           // w-48

        MenuItem { text: "Back"; shortcut: "⌘[" }
        MenuItem { text: "Forward"; enabled: false; shortcut: "⌘]" }
        MenuItem { text: "Reload"; shortcut: "⌘R" }

        Menu {
            title: "More Tools"
            implicitWidth: 176       // w-44

            MenuItem { text: "Save Page..." }
            MenuItem { text: "Create Shortcut..." }
            MenuItem { text: "Name Window..." }
            MenuSeparator {}
            MenuItem { text: "Developer Tools" }
            MenuSeparator {}
            MenuItem { text: "Delete"; destructive: true }
        }

        MenuSeparator {}
        MenuCheckboxItem { text: "Show Bookmarks"; checked: true }
        MenuCheckboxItem { text: "Show Full URLs" }

        MenuSeparator {}
        MenuLabel { text: "People" }
        MenuRadioItem { text: "Pedro Duarte"; checked: true }
        MenuRadioItem { text: "Colm Tuite" }
    }
}
