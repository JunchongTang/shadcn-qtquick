import QtQuick
import QtQuick.Controls.Basic as QC
import Shadcn

// 单选项:两个互斥选择组。用两个 ButtonGroup 隔离(否则同一 Menu 内会被统一互斥)。
Item {
    id: area
    implicitWidth: 320
    implicitHeight: 180

    // 独立的两个单选组(声明于区域内,仅作分组容器)
    QC.ButtonGroup { id: peopleGroup }
    QC.ButtonGroup { id: themeGroup }

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

        MenuLabel { text: "People" }
        MenuRadioItem { text: "Pedro Duarte"; checked: true; QC.ButtonGroup.group: peopleGroup }
        MenuRadioItem { text: "Colm Tuite"; QC.ButtonGroup.group: peopleGroup }
        MenuSeparator {}
        MenuLabel { text: "Theme" }
        MenuRadioItem { text: "Light"; checked: true; QC.ButtonGroup.group: themeGroup }
        MenuRadioItem { text: "Dark"; QC.ButtonGroup.group: themeGroup }
        MenuRadioItem { text: "System"; QC.ButtonGroup.group: themeGroup }
    }
}
