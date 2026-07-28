pragma ComponentBehavior: Bound

import QtQuick
import Shadcn

// Charts landing page — mirrors ui.shadcn.com/charts: a hero header, a row of
// chart-type tabs (Area / Bar / Line / Pie / Radar / Radial), and the selected
// type's demo cards in a wrapping grid. Cards are the existing demos under
// qrc:/demos/chart/.
Item {
    id: page

    // Emitted by the header's Documentation button; the gallery navigates to the
    // Chart component page.
    signal documentationRequested()

    property string chartType: "area"

    readonly property var typeTabs: [
        { id: "area",   label: qsTr("Area Charts") },
        { id: "bar",    label: qsTr("Bar Charts") },
        { id: "line",   label: qsTr("Line Charts") },
        { id: "pie",    label: qsTr("Pie Charts") },
        { id: "radar",  label: qsTr("Radar Charts") },
        { id: "radial", label: qsTr("Radial Charts") }
    ]
    // Full-width interactive chart shown at the top of a type (empty = none).
    readonly property var fullWidthByType: ({
        "area": "AreaInteractive",
        "bar":  "BarInteractive",
        "line": "LineInteractive"
    })
    readonly property var cardsByType: ({
        "area":   ["Area", "AreaLinear", "AreaStep", "AreaStacked", "AreaGradient", "AreaAxes"],
        "bar":    ["Bar", "BarHorizontal", "BarMultiple", "BarLabel", "BarNegative"],
        "line":   ["Line", "LineLinear", "LineStep", "LineDots", "LineMultiple"],
        "pie":    ["Pie", "PieDonut"],
        "radar":  ["Radar", "RadarDots", "RadarLinesOnly", "RadarLabelCustom", "RadarGridCustom", "RadarGridNone", "RadarGridCircle", "RadarGridCircleNoLines", "RadarGridCircleFill", "RadarGridFill", "RadarMultiple", "RadarLegend"],
        "radial": ["RadialSimple", "RadialLabel", "RadialGrid", "RadialText", "RadialShape", "RadialStacked"]
    })

    ScrollView {
        id: scroll
        anchors.fill: parent
        clip: true
        contentWidth: availableWidth

        Column {
            id: col
            x: 40
            y: 40
            width: scroll.availableWidth - 80
            spacing: 20
            bottomPadding: 48

            // ---- Hero header ----
            Text {
                text: qsTr("Beautiful Charts & Graphs")
                color: Theme.foreground
                font.pixelSize: 40
                font.weight: Font.Bold
                width: col.width
                wrapMode: Text.Wrap
            }
            Text {
                text: qsTr("A collection of ready-to-use chart components, ported from shadcn/ui "
                         + "and drawn with Qt Quick Canvas. From basic charts to rich data displays.")
                color: Theme.mutedForeground
                font.pixelSize: Theme.textLg
                width: Math.min(col.width, 640)
                wrapMode: Text.Wrap
            }
            Row {
                spacing: 8
                topPadding: 4
                Button {
                    text: qsTr("Browse Charts")
                    size: Button.Sm
                    onClicked: if (scroll.contentItem) scroll.contentItem.contentY = Math.max(0, navRow.y + col.y - 24)
                }
                Button {
                    text: qsTr("Documentation")
                    variant: Button.Ghost
                    size: Button.Sm
                    onClicked: page.documentationRequested()
                }
            }

            Item { width: 1; height: 8 }

            // ---- Chart-type tabs ----
            Column {
                width: col.width
                spacing: 0
                Row {
                    id: navRow
                    spacing: 0
                    Repeater {
                        model: page.typeTabs
                        delegate: Text {
                            required property var modelData
                            text: modelData.label
                            height: 32
                            leftPadding: 16
                            rightPadding: 16
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: Theme.textBase
                            font.weight: Font.Medium
                            color: page.chartType === modelData.id ? Theme.primary : Theme.mutedForeground
                            HoverHandler { cursorShape: Qt.PointingHandCursor }
                            TapHandler { onTapped: page.chartType = modelData.id }
                        }
                    }
                }
                Rectangle { width: col.width; height: 1; color: Theme.border }
            }

            // ---- Full-width interactive chart (when the type has one) ----
            Loader {
                id: fullWidthCard
                readonly property string src: page.fullWidthByType[page.chartType] || ""
                width: col.width
                active: src !== ""
                visible: src !== ""
                source: src !== "" ? "qrc:/demos/chart/" + src + ".qml" : ""
            }

            // ---- Grid of the selected type's charts ----
            // Responsive like ui.shadcn.com/charts: 1 / 2 / 3 columns depending
            // on the available width, with cells that stretch to fill it so the
            // grid always spans the content area rather than left-aligning.
            Grid {
                id: grid
                width: col.width
                columns: col.width >= 1000 ? 3 : (col.width >= 620 ? 2 : 1)
                spacing: 24
                readonly property real cellW: (width - (columns - 1) * spacing) / columns
                // Equal card heights: every cell adopts the tallest card's natural
                // height so rows line up (mirrors the official items-stretch grid).
                property real cellH: 0
                function _recalcH() {
                    var m = 0
                    for (var i = 0; i < children.length; i++) {
                        var c = children[i]
                        if (c && c.implicitHeight > m) m = c.implicitHeight
                    }
                    cellH = m
                }
                Repeater {
                    model: page.cardsByType[page.chartType]
                    onModelChanged: grid.cellH = 0
                    delegate: Loader {
                        required property string modelData
                        width: grid.cellW
                        height: grid.cellH > 0 ? grid.cellH : implicitHeight
                        source: "qrc:/demos/chart/" + modelData + ".qml"
                        onLoaded: grid._recalcH()
                        onImplicitHeightChanged: grid._recalcH()
                    }
                }
            }
        }
    }
}
