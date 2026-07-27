import QtQuick
import QtQuick.Controls.Basic as QC
import Shadcn

// Radio items: two mutually exclusive selection groups. Isolate them with two ButtonGroups (otherwise a single Menu makes them all exclusive together).
Item {
    id: area
    implicitWidth: 320
    implicitHeight: 180

    // Two independent radio groups (declared in the area, just grouping containers)
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
        text: qsTr("Right click here")
        color: Theme.foreground
        font.pixelSize: Theme.textSm
    }

    ContextMenu {
        target: area

        MenuLabel { text: qsTr("People") }
        MenuRadioItem { text: qsTr("Pedro Duarte"); checked: true; QC.ButtonGroup.group: peopleGroup }
        MenuRadioItem { text: qsTr("Colm Tuite"); QC.ButtonGroup.group: peopleGroup }
        MenuSeparator {}
        MenuLabel { text: qsTr("Theme") }
        MenuRadioItem { text: qsTr("Light"); checked: true; QC.ButtonGroup.group: themeGroup }
        MenuRadioItem { text: qsTr("Dark"); QC.ButtonGroup.group: themeGroup }
        MenuRadioItem { text: qsTr("System"); QC.ButtonGroup.group: themeGroup }
    }
}
